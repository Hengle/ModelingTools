unit ModflowRES_WriterUnit;

interface

uses SysUtils, Classes, CustomModflowWriterUnit, ModflowCellUnit,
  ModflowPackageSelectionUnit, ScreenObjectUnit, ModflowBoundaryUnit,
  OrderedCollectionUnit, ModflowResUnit, GoPhastTypes;

type
  TPestData = record
    PestName: string;
    PestSeriesName: string;
    PestSeriesMethod: TPestParamMethod;
  end;


  TModflowRES_Writer = class(TCustomTransientArrayWriter)
  private
    NRES: integer;
    NRESOP: integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteDataSet7;
    procedure WriteCells(CellList: TList; const DataSetIdentifier,
      VariableIdentifiers: string);
    procedure CheckCells;
    procedure EvaluateStartAndEndHead(ResItem: TResItem; Reservoir: TResBoundary; var StartHead,
      EndHead: double; var StartHeadPest, EndHeadPest: TPestData);
    procedure WriteFileInternal;
  protected
    function CellType: TValueCellType; override;
    function GetBoundary(ScreenObject: TScreenObject): TModflowBoundary;
      override;
    function Prefix: string; override;
    procedure Evaluate; override;
    class function Extension: string; override;
    function Package: TModflowPackageSelection; override;
    function ParameterType: TParameterType; override;
    procedure WriteStressPeriods(const VariableIdentifiers, DataSetIdentifier,
      DS5, D7PNameIname, D7PName: string); override;
  public
    procedure WriteFile(const AFileName: string);

  end;

implementation

uses RbwParser, ModflowUnitNumbers, DataSetUnit, PhastModelUnit,
  ModflowTimeUnit, frmProgressUnit, frmFormulaErrorsUnit, Forms,
  frmErrorsAndWarningsUnit, SolidGeom, PestParamRoots,
  ModflowParameterUnit, DataSetNamesUnit;

resourcestring
  StrNoReservoirsDefine = 'No reservoirs defined';
  StrTheReservoirPackag = 'The Reservoir package is selected but no reservoi' +
  'rs have been defined.';
  StrEndingHeadForThe = '(Ending head for the %s)';
  StrStartingHeadForT = '(Starting head for the %s)';
  StrEvaluatingRESPacka = 'Evaluating RES Package data.';
  StrWritingStressP = '    Writing Stress Period %d';
  StrWritingRESPackage = 'Writing RES Package input.';
  StrTheRESPackageIsN = 'The RES package is not supported by MT3DMS.';
  StrMT3DMSVersion53D = 'MT3DMS version 5.3 does not suppport the RES packag' +
  'e.';
  StrTheReservoirsAtThStart = 'The reservoirs at the following cells will be inac' +
  'tive because the start stage is less than the bottom of the cell';
  StrTheReservoirsAtThEnd = 'The reservoirs at the following cells will be inac' +
  'tive because the end stage is less than the bottom of the cell';
  StrLayerRowColumn = '(Layer, Row, Column), Head, Object) = (%0:d, %1:d, %2:d), %3:g %4:s';
  StrInvalidReservoirLa = 'Invalid Reservoir layer.  If this is a quasi-3d m' +
  'odel, remember that non-simulated layers are not MODFLOW layers.';
  StrTheReservoirLayer = 'The reservoir layer (%0:d) at (Row, Col) = (%1:d, ' +
  '%2:d) is outside the range of valid MODFLOW layers.';
  StrTheReservoirLayers = 'The reservoir layers at the following cells are b' +
  'elow non-simulated layers. Be careful that this is the correct MODFLOW la' +
  'yer rather than model layer.';
  StrReservoirLayer0 = 'Reservoir layer = %0:d. (Row, Col) = (%1:d, %2:d)';

{ TModflowRES_Writer }

function TModflowRES_Writer.CellType: TValueCellType;
begin
  result := TRes_Cell;
end;

procedure TModflowRES_Writer.CheckCells;
var
  List: TValueCellList;
  IRESL: TDataArray;
  RESBOT: TDataArray;
  Active: TDataArray;
  CellIndex: Integer;
  ACell: TRes_Cell;
  Layer: Integer;
  LayerIndex: Integer;
  Reservoirs: TList;
  ScreenObjectIndex: Integer;
  AScreenObject: TScreenObject;
  Reservoir: TResBoundary;
  StartTime: Double;
  EndTime: Double;
  AResItem: TResItem;
  ReservoirIndex: Integer;
  ItemIndex: Integer;
  StartHead: Double;
  EndHead: Double;
  RowIndex: Integer;
  ResID: array of array of Integer;
  ColIndex: Integer;
  ScreenObject: TScreenObject;
  StartHeadPest: TPestData;
  EndHeadPest: TPestData;
  ResLayer: Integer;
  LayerCount: Integer;
begin
  LayerCount := Model.ModflowLayerCount;
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrTheReservoirsAtThStart);
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrTheReservoirsAtThEnd);
  if Values.Count > 0 then
  begin
    List := Values[0];// as TValueCellList;
  end
  else
  begin
    frmErrorsAndWarnings.AddError(Model, StrNoReservoirsDefine,
      StrTheReservoirPackag);
    Exit;
  end;
  IRESL := nil;
  if NRESOP = 2 then
  begin
    IRESL := Model.DataArrayManager.GetDataSetByName(rsResLayer);
    Assert(IRESL <> nil);
  end;
  RESBOT := Model.DataArrayManager.GetDataSetByName(rsResBottom);
  Active := Model.DataArrayManager.GetDataSetByName(rsActive);
//  Grid := Model.Grid;
  Active.Initialize;
  SetLength(ResID, Active.RowCount, Active.ColumnCount);
  for RowIndex := 0 to Active.RowCount - 1 do
  begin
    for ColIndex := 0 to Active.ColumnCount - 1 do
    begin
      ResID[RowIndex, ColIndex] := 0;
    end;
  end;
  for CellIndex := 0 to List.Count - 1 do
  begin
    ACell := List[CellIndex] as TRes_Cell;
    ResID[ACell.Row, ACell.Column] := ACell.ResID;
  end;
  Reservoirs := TList.Create;
  try
    StartTime := Model.ModflowFullStressPeriods.First.StartTime;
    EndTime :=  Model.ModflowFullStressPeriods.Last.EndTime;
    for ScreenObjectIndex := 0 to Model.ScreenObjectCount - 1 do
    begin
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;
      AScreenObject := Model.ScreenObjects[ScreenObjectIndex];
      if (AScreenObject.ModflowResBoundary <> nil)
        and AScreenObject.ModflowResBoundary.Used then
      begin
        Reservoirs.Add(AScreenObject.ModflowResBoundary);
      end;
    end;
    for ReservoirIndex := 0 to Reservoirs.Count - 1 do
    begin
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;
      Reservoir := Reservoirs[ReservoirIndex];
      for ItemIndex := 0 to Reservoir.Values.Count - 1 do
      begin
        AResItem := Reservoir.Values[ItemIndex] as TResItem;
        if (AResItem.StartTime < EndTime)
          and (AResItem.EndTime > StartTime) then
        begin
          EvaluateStartAndEndHead(AResItem,Reservoir, StartHead, EndHead,
            StartHeadPest, EndHeadPest);
          for RowIndex := 0 to Active.RowCount - 1 do
          begin
            for ColIndex := 0 to Active.ColumnCount - 1 do
            begin
              if ResID[RowIndex, ColIndex] = Reservoir.ResId then
              begin
                Layer := -1;
                Case NRESOP of
                  1:
                    begin
                      Layer := 0
                    end;
                  2:
                    begin
                      ResLayer := IRESL.IntegerData[0,RowIndex,ColIndex];
                      if (ResLayer < 1) or (ResLayer > LayerCount) then
                      begin
                        frmErrorsAndWarnings.AddError(Model, StrInvalidReservoirLa,
                          Format(StrTheReservoirLayer, [ResLayer, RowIndex+1,
                          ColIndex+1]));
                        Layer := 0;
                      end
                      else
                      begin
                        Layer := Model.ModflowLayerToDataSetLayer(ResLayer);
                        for LayerIndex := 0 to Layer do
                        begin
                          if not Model.IsLayerSimulated(LayerIndex) then
                          begin
                            frmErrorsAndWarnings.AddWarning(Model,
                              StrTheReservoirLayers,
                              Format(StrReservoirLayer0, [ResLayer, RowIndex+1,
                              ColIndex+1]));
                            break;
                          end;
                        end;
                      end;
                    end;
                  3:
                    begin
                      for LayerIndex := 0 to Active.LayerCount - 1 do
                      begin
                        if Active.BooleanData[LayerIndex,RowIndex,ColIndex] then
                        begin
                          Layer := LayerIndex;
                          Break;
                        end;
                      end;
                    end;
                  else
                    Assert(False);
                End;
                if Layer >= 0 then
                begin
//                  LayerElevation := Grid.CellElevation[ColIndex, RowIndex, Layer];
                  if RESBOT.RealData[0,RowIndex,ColIndex] >= StartHead then
                  begin
                    ScreenObject := Reservoir.ScreenObject as TScreenObject;
                    frmErrorsAndWarnings.AddWarning(Model, StrTheReservoirsAtThStart,
                      Format(StrLayerRowColumn,
                      [Layer+1, RowIndex+1, ColIndex+1, StartHead, ScreenObject.Name]), ScreenObject);
                  end;
                  if RESBOT.RealData[0,RowIndex,ColIndex] >= EndHead then
                  begin
                    ScreenObject := Reservoir.ScreenObject as TScreenObject;
                    frmErrorsAndWarnings.AddWarning(Model, StrTheReservoirsAtThEnd,
                      Format(StrLayerRowColumn,
                      [Layer+1, RowIndex+1, ColIndex+1, EndHead, ScreenObject.Name]), ScreenObject);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

  finally
    Reservoirs.Free;
  end;
end;

procedure TModflowRES_Writer.Evaluate;
var
  Index: Integer;
  AScreenObject: TScreenObject;
begin
  frmErrorsAndWarnings.BeginUpdate;
  try
    case Model.ModflowPackages.ResPackage.LayerOption of
      loTop: NRESOP := 1;
      loSpecified: NRESOP := 2;
      loTopActive: NRESOP := 3;
      else Assert(False);
    end;
    frmProgressMM.AddMessage(StrEvaluatingRESPacka);
    frmErrorsAndWarnings.RemoveErrorGroup(Model, StrNoReservoirsDefine);
    frmErrorsAndWarnings.RemoveWarningGroup(Model, StrTheRESPackageIsN);
    frmErrorsAndWarnings.RemoveErrorGroup(Model, StrInvalidReservoirLa);
    frmErrorsAndWarnings.RemoveWarningGroup(Model, StrTheReservoirLayers);

    if Model.ModflowPackages.Mt3dBasic.IsSelected then
    begin
      frmErrorsAndWarnings.AddWarning(Model, StrTheRESPackageIsN,
        StrMT3DMSVersion53D);
    end;

    NRES := 0;
    for Index := 0 to Model.ScreenObjectCount - 1 do
    begin
      AScreenObject := Model.ScreenObjects[Index];
      if AScreenObject.Deleted then
      begin
        Continue;
      end;
      if not AScreenObject.UsedModels.UsesModel(Model) then
      begin
        Continue;
      end;
      if (AScreenObject.ModflowResBoundary <> nil)
        and AScreenObject.ModflowResBoundary.Used then
      begin
        Assert(AScreenObject.ViewDirection = vdTop);
        Inc(NRES);
        AScreenObject.ModflowResBoundary.ResId := NRES;
      end;
    end;
    if NRES = 0 then
    begin
      frmErrorsAndWarnings.AddError(Model, StrNoReservoirsDefine,
        StrTheReservoirPackag);
    end;
    inherited;
    CheckCells;
  finally
    frmErrorsAndWarnings.EndUpdate;
  end;
end;

class function TModflowRES_Writer.Extension: string;
begin
  result := '.resv';
end;

function TModflowRES_Writer.GetBoundary(
  ScreenObject: TScreenObject): TModflowBoundary;
begin
  result := ScreenObject.ModflowResBoundary;
end;

function TModflowRES_Writer.Package: TModflowPackageSelection;
begin
  result := Model.ModflowPackages.ResPackage;
end;

function TModflowRES_Writer.ParameterType: TParameterType;
begin
  result := ptUndefined;
end;

function TModflowRES_Writer.Prefix: string;
begin
  result := '';
end;

procedure TModflowRES_Writer.WriteCells(CellList: TList;
  const DataSetIdentifier, VariableIdentifiers: string);
var
  DefaultValue: double;
  DataType: TRbwDataType;
  DataTypeIndex: integer;
  Comment: string;
  Dummy: TDataArray;
begin
  DefaultValue := 0;
  DataType := rdtInteger;
  DataTypeIndex := 0;
  Comment := DataSetIdentifier + ' ' + VariableIdentifiers;
  WriteTransient2DArray(Comment, DataTypeIndex, DataType,
    DefaultValue, CellList, umAssign, False, Dummy, VariableIdentifiers);
end;

procedure TModflowRES_Writer.WriteDataSet1;
var
  IRESCB, IRESPT, NPTS: integer;
begin
  GetFlowUnitNumber(IRESCB);
  if Model.ModflowPackages.ResPackage.PrintStage then
  begin
    IRESPT := 1;
  end
  else
  begin
    IRESPT := 0;
  end;
  NPTS := Model.ModflowPackages.ResPackage.TableStages;

  WriteString(FixedFormattedInteger(NRES, 10));
  WriteString(FixedFormattedInteger(IRESCB, 10));
  WriteString(FixedFormattedInteger(NRESOP, 10));
  WriteString(FixedFormattedInteger(IRESPT, 10));
  WriteString(FixedFormattedInteger(NPTS, 10));
  WriteString(' # Data Set 1: NRES IRESCB NRESOP IRESPT NPTS');
  NewLine;
end;

procedure TModflowRES_Writer.WriteDataSet2;
var
  List: TList;
  DataSetIdentifier: string;
  VariableIdentifiers: string;
begin
  List := Values[0];
  DataSetIdentifier := ' # Data Set 2:';
  VariableIdentifiers := 'IRES';
  WriteCells(List, DataSetIdentifier, VariableIdentifiers)
end;

procedure TModflowRES_Writer.WriteDataSet3;
var
  DataArray: TDataArray;
begin
  if NRESOP = 2 then
  begin
    DataArray := Model.DataArrayManager.GetDataSetByName(rsResLayer);
    Assert(DataArray <> nil);
    WriteArray(DataArray, 0, ' # Data Set 3: IRESL', StrNoValueAssigned, 'IRESL');
  end;
end;

procedure TModflowRES_Writer.WriteDataSet4;
var
  DataArray: TDataArray;
begin
  DataArray := Model.DataArrayManager.GetDataSetByName(rsResBottom);
  Assert(DataArray <> nil);
  WriteArray(DataArray, 0, ' # Data Set 4: BRES', StrNoValueAssigned, 'BRES');
  WritePestZones(DataArray, FInputFileName, StrBRES, '', 'BRE');
end;

procedure TModflowRES_Writer.WriteDataSet5;
var
  DataArray: TDataArray;
begin
  DataArray := Model.DataArrayManager.GetDataSetByName(rsResKv);
  Assert(DataArray <> nil);
  WriteArray(DataArray, 0, ' # Data Set 5: HCres', StrNoValueAssigned, 'HCres');
  WritePestZones(DataArray, FInputFileName, StrHCre, '', 'HCR');
end;

procedure TModflowRES_Writer.WriteDataSet6;
var
  DataArray: TDataArray;
begin
  DataArray := Model.DataArrayManager.GetDataSetByName(rsResBedThickness);
  Assert(DataArray <> nil);
  WriteArray(DataArray, 0, ' # Data Set 6: Rbthck', StrNoValueAssigned, 'Rbthck');
  WritePestZones(DataArray, FInputFileName, StrRbth, '', 'RBT');
end;

procedure TModflowRES_Writer.EvaluateStartAndEndHead(ResItem: TResItem; Reservoir: TResBoundary;
  var StartHead, EndHead: double; var StartHeadPest, EndHeadPest: TPestData);
var
  Compiler: TRbwParser;
  TempFormula: string;
  Expression: TExpression;
  ScreenObject: TScreenObject;
  Param: TModflowSteadyParameter;
begin
  Assert(ResItem <> nil);
  Compiler := Model.rpThreeDFormulaCompiler;

  StartHeadPest.PestName := '';
  StartHeadPest.PestSeriesName := Reservoir.PestStartHeadFormula;
  StartHeadPest.PestSeriesMethod := Reservoir.PestStartHeadMethod;

  EndHeadPest.PestName := '';
  EndHeadPest.PestSeriesName := Reservoir.PestEndHeadFormula;
  EndHeadPest.PestSeriesMethod := Reservoir.PestEndHeadMethod;

  TempFormula := ResItem.StartHead;
  Param := Model.GetPestParameterByName(TempFormula);
  if Param <> nil then
  begin
    Param.IsUsedInTemplate := True;
    StartHeadPest.PestName := Param.ParameterName;
    StartHead := Param.Value;
    FPestParamUsed := True;
  end
  else
  begin
    try
      Compiler.Compile(TempFormula);
      Expression := Compiler.CurrentExpression;
      Expression.Evaluate;
    except on E: ERbwParserError do
      begin
        ScreenObject := Reservoir.ScreenObject as TScreenObject;
        frmFormulaErrors.AddFormulaError(ScreenObject.Name,
          Format(StrEndingHeadForThe,
          [sLineBreak+Package.PackageIdentifier]),
          TempFormula, E.Message);

        ResItem.StartHead := '0.';
        TempFormula := ResItem.StartHead;
        Compiler.Compile(TempFormula);
        Expression := Compiler.CurrentExpression;
        Expression.Evaluate;
      end;
    end;
    StartHead := Expression.DoubleResult;
    StartHeadPest.PestName := '';
  end;
  Param := Model.GetPestParameterByName(StartHeadPest.PestSeriesName);
  if Param <> nil then
  begin
    Param.IsUsedInTemplate := True;
    case StartHeadPest.PestSeriesMethod of
      ppmAdd:
        begin
          StartHead := StartHead + Param.Value;
        end;
      ppmMultiply:
        begin
          StartHead := StartHead * Param.Value;
        end;
    end;
  end;

  TempFormula := ResItem.EndHead;
  Param := Model.GetPestParameterByName(TempFormula);
  if Param <> nil then
  begin
    Param.IsUsedInTemplate := True;
    EndHeadPest.PestName := Param.ParameterName;
    EndHead := Param.Value;
    FPestParamUsed := True;
  end
  else
  begin
    try
      Compiler.Compile(TempFormula);
      Expression := Compiler.CurrentExpression;
      Expression.Evaluate;
    except on E: ERbwParserError do
      begin
        ScreenObject := Reservoir.ScreenObject as TScreenObject;
        frmFormulaErrors.AddFormulaError(ScreenObject.Name,
          Format(StrEndingHeadForThe,
          [sLineBreak+Package.PackageIdentifier]),
          TempFormula, E.Message);

        ResItem.EndHead := '0.';
        TempFormula := ResItem.EndHead;
        Compiler.Compile(TempFormula);
        Expression := Compiler.CurrentExpression;
        Expression.Evaluate;
      end;
    end;
    EndHead := Expression.DoubleResult;
    EndHeadPest.PestName := '';
  end;
  Param := Model.GetPestParameterByName(EndHeadPest.PestSeriesName);
  if Param <> nil then
  begin
    Param.IsUsedInTemplate := True;
    case EndHeadPest.PestSeriesMethod of
      ppmAdd:
        begin
          EndHead := EndHead + Param.Value;
        end;
      ppmMultiply:
        begin
          EndHead := EndHead * Param.Value;
        end;
    end;
  end;
end;

procedure TModflowRES_Writer.WriteDataSet7;
const
  Epsilon = 1E-10;
var
  Index: integer;
  Item: TModflowStressPeriod;
  Reservoirs: TList;
  AScreenObject: TScreenObject;
  Reservoir: TResBoundary;
  ReservoirIndex: integer;
  ResItem: TResItem;
  StartHead: double;
  EndHead: double;
  ScreenObjectIndex: Integer;
  ExportedStartHead: double;
  ExportedEndHead: double;
  UseStartOnly: Boolean;
  UseLastOnly: Boolean;
  StartHeadPest: TPestData;
  EndHeadPest: TPestData;
  ExportedStartHeadPest: string;
  ExportedEndHeadPest: string;
  StartHeadFormula: string;
  EndHeadFormula: string;
  ExtendedTemplateCharacter: Char;
  Fraction: Extended;
  OldDecimalSeparator: Char;
begin
  ExtendedTemplateCharacter := Model.PestProperties.ExtendedTemplateCharacter;
  Reservoirs := TList.Create;
  try
    for ScreenObjectIndex := 0 to Model.ScreenObjectCount - 1 do
    begin
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;
      AScreenObject := Model.ScreenObjects[ScreenObjectIndex];
      if AScreenObject.Deleted then
      begin
        Continue;
      end;
      if not AScreenObject.UsedModels.UsesModel(Model) then
      begin
        Continue;
      end;

      if (AScreenObject.ModflowResBoundary <> nil)
        and AScreenObject.ModflowResBoundary.Used then
      begin
        Reservoirs.Add(AScreenObject.ModflowResBoundary);
      end;
    end;
    for Index := 0 to Model.ModflowFullStressPeriods.Count - 1 do
    begin
      frmProgressMM.AddMessage(Format(StrWritingStressP, [Index+1]));
      Application.ProcessMessages;
      if not frmProgressMM.ShouldContinue then
      begin
        Exit;
      end;
      Item := Model.ModflowFullStressPeriods.Items[Index];
      for ReservoirIndex := 0 to Reservoirs.Count - 1 do
      begin
        Application.ProcessMessages;
        if not frmProgressMM.ShouldContinue then
        begin
          Exit;
        end;
        Reservoir := Reservoirs[ReservoirIndex];

        UseStartOnly := False;
        UseLastOnly := False;
        ResItem := Reservoir.Values.GetItemContainingTime(Item.StartTime) as TResItem;
        if ResItem <> nil then
        begin
          if (ResItem.EndTime <= Item.StartTime) then
          begin
            UseLastOnly := True;
          end;
        end
        else
        if (ResItem = nil) or (ResItem.EndTime <= Item.StartTime)
          or (ResItem.StartTime > Item.EndTime) then
        begin
          ResItem := Reservoir.Values.First as TResItem;
          if ResItem.StartTime >= Item.EndTime then
          begin
            UseStartOnly := True;
          end
          else
          begin
            ResItem := Reservoir.Values.Last as TResItem;
            if ResItem.EndTime <= Item.StartTime then
            begin
              UseLastOnly := True;
            end;
          end;
        end;
        Assert(ResItem <> nil);

        EvaluateStartAndEndHead(ResItem, Reservoir, StartHead, EndHead,
          StartHeadPest, EndHeadPest);

        if UseStartOnly then
        begin
          ExportedStartHead := StartHead;
          ExportedEndHead := StartHead;
          ExportedStartHeadPest := GetPestTemplateFormulaOrValue(StartHead,
            StartHeadPest.PestName, StartHeadPest.PestSeriesName,
            StartHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
          ExportedEndHeadPest := ExportedStartHeadPest;
        end
        else if UseLastOnly then
        begin
          ExportedStartHead := EndHead;
          ExportedEndHead := EndHead;
          ExportedStartHeadPest := GetPestTemplateFormulaOrValue(EndHead,
            EndHeadPest.PestName, EndHeadPest.PestSeriesName,
            EndHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
          ExportedEndHeadPest := ExportedStartHeadPest;
        end
        else
        begin
          if NearlyTheSame(ResItem.StartTime, Item.StartTime, Epsilon) then
          begin
            ExportedStartHead := StartHead;
            ExportedStartHeadPest := GetPestTemplateFormulaOrValue(StartHead,
            StartHeadPest.PestName, StartHeadPest.PestSeriesName,
            StartHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
          end
          else
          begin
            Assert(ResItem.StartTime < Item.StartTime);
            Fraction := (Item.StartTime-ResItem.StartTime)
                / (ResItem.EndTime-ResItem.StartTime);
            if not WritingTemplate or
              ((StartHeadPest.PestName = '') and (EndHeadPest.PestName = '')
              and (StartHeadPest.PestSeriesName = '') and (EndHeadPest.PestSeriesName = '')) then
            begin
              ExportedStartHead := StartHead + Fraction*(EndHead-StartHead);
              ExportedStartHeadPest := '';
            end
            else
            begin
              ExportedStartHead := 1e-31;
              StartHeadFormula := GetPestTemplateFormulaOrValue(StartHead,
                StartHeadPest.PestName, StartHeadPest.PestSeriesName,
                StartHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
              EndHeadFormula := GetPestTemplateFormulaOrValue(EndHead,
                EndHeadPest.PestName, EndHeadPest.PestSeriesName,
                EndHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
              OldDecimalSeparator := FormatSettings.DecimalSeparator;
              FormatSettings.DecimalSeparator := '.';
              try
                ExportedStartHeadPest := Format('(%0:s) + %1:g * ((%2:s) - (%0:s))',
                  [StartHeadFormula, Fraction, EndHeadFormula]);
              finally
                FormatSettings.DecimalSeparator := OldDecimalSeparator;
              end;

            end;
          end;

          if NearlyTheSame(ResItem.EndTime, Item.EndTime, Epsilon) then
          begin
            ExportedEndHead := EndHead;
            ExportedEndHeadPest := GetPestTemplateFormulaOrValue(EndHead,
              EndHeadPest.PestName, EndHeadPest.PestSeriesName,
              EndHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
          end
          else
          begin
            Assert (ResItem.EndTime > Item.EndTime);
            Fraction := (Item.EndTime-ResItem.StartTime)
              / (ResItem.EndTime-ResItem.StartTime);
            if not WritingTemplate or
              ((StartHeadPest.PestName = '') and (EndHeadPest.PestName = '')
              and (StartHeadPest.PestSeriesName = '') and (EndHeadPest.PestSeriesName = '')) then
            begin
              ExportedEndHead := StartHead + Fraction*(EndHead-StartHead);
              ExportedEndHeadPest := ''
            end
            else
            begin
              ExportedEndHead := 1e-31;
              StartHeadFormula := GetPestTemplateFormulaOrValue(StartHead,
                StartHeadPest.PestName, StartHeadPest.PestSeriesName,
                StartHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
              EndHeadFormula := GetPestTemplateFormulaOrValue(EndHead,
                EndHeadPest.PestName, EndHeadPest.PestSeriesName,
                EndHeadPest.PestSeriesMethod, nil, Reservoir.ScreenObject);
              OldDecimalSeparator := FormatSettings.DecimalSeparator;
              FormatSettings.DecimalSeparator := '.';
              try
                ExportedEndHeadPest := Format('(%0:s) + %1:g * ((%2:s) - (%0:s))',
                  [StartHeadFormula, Fraction, EndHeadFormula]);
              finally
                FormatSettings.DecimalSeparator := OldDecimalSeparator;
              end;
            end;
          end;
        end;

        if (not WritingTemplate) or
          ((StartHeadPest.PestName = '') and (EndHeadPest.PestName = '')
          and (StartHeadPest.PestSeriesName = '') and (EndHeadPest.PestSeriesName = '')) then
        begin
          WriteF10Float(ExportedStartHead);
          WriteF10Float(ExportedEndHead);
        end
        else
        begin
          if ExportedStartHeadPest = '' then
          begin
            WriteF10Float(ExportedStartHead);
          end
          else
          begin
            ExportedStartHeadPest := Format(' %0:s        %1:s%0:s',
              [ExtendedTemplateCharacter, ExportedStartHeadPest]);
            WriteString(ExportedStartHeadPest)
          end;
          if ExportedEndHeadPest = '' then
          begin
            WriteF10Float(ExportedEndHead);
          end
          else
          begin
            ExportedEndHeadPest := Format(' %0:s        %1:s%0:s',
              [ExtendedTemplateCharacter, ExportedEndHeadPest]);
            WriteString(ExportedEndHeadPest)
          end;
        end;
        WriteString(' # Data Set 7, Stress period');
        WriteInteger(Index + 1);
        WriteString(': Ststage Endstage');
        NewLine;
      end;
    end;
  finally
    Reservoirs.Free;
  end;
end;

procedure TModflowRES_Writer.WriteFile(const AFileName: string);
begin
  if not Package.IsSelected then
  begin
    Exit
  end;
  if Model.PackageGeneratedExternally(StrRES) then
  begin
    Exit;
  end;
  if Model.ModelSelection = msModflow2015 then
  begin
    Exit;
  end;
  FNameOfFile := FileName(AFileName);
  FInputFileName := FNameOfFile;
  WriteToNameFile(StrRES, Model.UnitNumbers.UnitNumber(StrRES), FNameOfFile, foInput, Model);
  Evaluate;
  if NRES = 0 then
  begin
    Exit;
  end;
  Application.ProcessMessages;
  if not frmProgressMM.ShouldContinue then
  begin
    Exit;
  end;
  ClearTimeLists(Model);
  FInputFileName := FNameOfFile;
  WriteFileInternal;

  if Model.PestUsed and FPestParamUsed then
  begin
    FNameOfFile := FNameOfFile + '.tpl';
    WritePestTemplateLine(FNameOfFile);
    WritingTemplate := True;
    WriteFileInternal;
  end;
end;

procedure TModflowRES_Writer.WriteFileInternal;
begin
  OpenFile(FNameOfFile);
  try
    //    WriteDataSet0;
    frmProgressMM.AddMessage(StrWritingRESPackage);
    WriteTemplateHeader;

    frmProgressMM.AddMessage(StrWritingDataSet1);
    WriteDataSet1;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet2);
    WriteDataSet2;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet3);
    WriteDataSet3;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet4);
    WriteDataSet4;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet5);
    WriteDataSet5;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet6);
    WriteDataSet6;
    Application.ProcessMessages;
    if not frmProgressMM.ShouldContinue then
    begin
      Exit;
    end;

    frmProgressMM.AddMessage(StrWritingDataSet7);
    WriteDataSet7;
  finally
    CloseFile;
  end;
end;

procedure TModflowRES_Writer.WriteStressPeriods(const VariableIdentifiers,
  DataSetIdentifier, DS5, D7PNameIname, D7PName: string);
begin
  inherited;
end;

end.
