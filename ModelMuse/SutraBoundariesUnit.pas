unit SutraBoundariesUnit;

interface

uses
  GoPhastTypes, Classes, ModflowBoundaryUnit,
  Generics.Collections, RbwParser,
  SysUtils, SutraBoundaryUnit, SutraGeneralBoundaryUnit,
  SutraGenTransBoundUnit, SutraPestObsUnit;

type
  TSutraBoundaries = class(TGoPhastPersistent)
  private
    FSpecifiedPressure: TSutraSpecifiedPressureBoundary;
    FFluidSource: TSutraFluidBoundary;
    FSpecifiedConcTemp: TSutraSpecifiedConcTempBoundary;
    FMassEnergySource: TSutraMassEnergySourceSinkBoundary;
    FObservations: TSutraObservations;
    FLake: TSutraLake;
    FGeneralFlowBoundary: TSutraGeneralFlowBoundary;
    FGenTransportBoundary: TSutraGeneralTransportBoundary;
    FSutraStateObs: TSutraStateObservations;
    procedure SetFluidSource(const Value: TSutraFluidBoundary);
    procedure SetMassEnergySource(
      const Value: TSutraMassEnergySourceSinkBoundary);
    procedure SetSpecifiedConcTemp(
      const Value: TSutraSpecifiedConcTempBoundary);
    procedure SetSpecifiedPressure(
      const Value: TSutraSpecifiedPressureBoundary);
    procedure SetObservations(const Value: TSutraObservations);
    procedure SetLake(const Value: TSutraLake);
    procedure SetGeneralFlowBoundary(const Value: TSutraGeneralFlowBoundary);
    procedure SetGenTransportBoundary(
      const Value: TSutraGeneralTransportBoundary);
    procedure SetSutraStateObs(const Value: TSutraStateObservations);
    function StoreSutraStateObs: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    { TODO -cRefactor : Consider replacing Model with a TNotifyEvent or interface. }
    //
    Constructor Create(Model: TBaseModel; ScreenObject: TObject);
    destructor Destroy; override;
//    procedure ResetObserversUptodate;
    procedure Changed;
    procedure Loaded;
    procedure ReplaceGUID;
  published
    property FluidSource: TSutraFluidBoundary read FFluidSource
      write SetFluidSource;
    property MassEnergySource: TSutraMassEnergySourceSinkBoundary
      read FMassEnergySource write SetMassEnergySource;
    property SpecifiedPressure: TSutraSpecifiedPressureBoundary
      read FSpecifiedPressure write SetSpecifiedPressure;
    property SpecifiedConcTemp: TSutraSpecifiedConcTempBoundary
      read FSpecifiedConcTemp write SetSpecifiedConcTemp;
    property Observations: TSutraObservations
      read FObservations write SetObservations;
    property Lake: TSutraLake read FLake write SetLake;
    property GeneralFlowBoundary: TSutraGeneralFlowBoundary
      read FGeneralFlowBoundary write SetGeneralFlowBoundary;
    property GenTransportBoundary: TSutraGeneralTransportBoundary
      read FGenTransportBoundary write SetGenTransportBoundary;
    property SutraStateObs: TSutraStateObservations read FSutraStateObs
      write SetSutraStateObs stored StoreSutraStateObs;
  end;

implementation

uses
  PhastModelUnit;



{ TSutraBoundaries }

procedure TSutraBoundaries.Assign(Source: TPersistent);
var
  SourceBoundaries: TSutraBoundaries;
begin
  if Source is TSutraBoundaries then
  begin
    SourceBoundaries := TSutraBoundaries(Source);
    FluidSource := SourceBoundaries.FluidSource;
    MassEnergySource := SourceBoundaries.MassEnergySource;
    SpecifiedPressure := SourceBoundaries.SpecifiedPressure;
    SpecifiedConcTemp := SourceBoundaries.SpecifiedConcTemp;
    Observations := SourceBoundaries.Observations;
    Lake := SourceBoundaries.Lake;
    GeneralFlowBoundary := SourceBoundaries.GeneralFlowBoundary;
    GenTransportBoundary := SourceBoundaries.GenTransportBoundary;
    SutraStateObs := SourceBoundaries.SutraStateObs;
  end
  else
  begin
    inherited;
  end;
end;

procedure TSutraBoundaries.Changed;
begin
  FluidSource.Changed;
  MassEnergySource.Changed;
  SpecifiedPressure.Changed;
  SpecifiedConcTemp.Changed;
//  Observations.Changed;
//  Lake.Changed;
  GeneralFlowBoundary.Changed;
  GenTransportBoundary.Changed;
//  SourceBoundaries..Changed;
end;

constructor TSutraBoundaries.Create(Model: TBaseModel; ScreenObject: TObject);
var
  InvalidateModelEvent: TNotifyEvent;
begin
  if Model = nil then
  begin
    InvalidateModelEvent := nil;
  end
  else
  begin
    InvalidateModelEvent := Model.DoInvalidate;
  end;
  inherited Create(InvalidateModelEvent);
  FFluidSource := TSutraFluidBoundary.Create(Model, ScreenObject);
  FMassEnergySource := TSutraMassEnergySourceSinkBoundary.Create(Model, ScreenObject);
  FSpecifiedPressure := TSutraSpecifiedPressureBoundary.Create(Model, ScreenObject);
  FSpecifiedConcTemp := TSutraSpecifiedConcTempBoundary.Create(Model, ScreenObject);
  FObservations := TSutraObservations.Create(InvalidateModelEvent);
  FLake := TSutraLake.Create(Model as TCustomModel, ScreenObject);
  FGeneralFlowBoundary := TSutraGeneralFlowBoundary.Create(Model, ScreenObject);
  FGenTransportBoundary := TSutraGeneralTransportBoundary.Create(Model, ScreenObject);
  FSutraStateObs := TSutraStateObservations.Create(Model, ScreenObject);
end;

destructor TSutraBoundaries.Destroy;
begin
  FSutraStateObs.Free;
  FGenTransportBoundary.Free;
  FGeneralFlowBoundary.Free;
  FLake.Free;
  FObservations.Free;
  FSpecifiedConcTemp.Free;
  FSpecifiedPressure.Free;
  FMassEnergySource.Free;
  FFluidSource.Free;
  inherited;
end;

procedure TSutraBoundaries.Loaded;
begin
  if FFluidSource <> nil then
  begin
    FFluidSource.Loaded;
  end;
  if FMassEnergySource <> nil then
  begin
    FMassEnergySource.Loaded;
  end;
  if FSpecifiedPressure <> nil then
  begin
    FSpecifiedPressure.Loaded;
  end;
  if FSpecifiedConcTemp <> nil then
  begin
    FSpecifiedConcTemp.Loaded;
  end;
  if FGeneralFlowBoundary <> nil then
  begin
    FGeneralFlowBoundary.Loaded;
  end;
//  if FSutraStateObs <> nil then
//  begin
//    FSutraStateObs.Loaded;
//  end;
end;

procedure TSutraBoundaries.ReplaceGUID;
begin
  SutraStateObs.ReplaceGUID;
end;

//procedure TSutraBoundaries.ResetObserversUptodate;
//begin
//  FluidSource.ResetObserversUptodate;
//  MassEnergySource.ResetObserversUptodate;
//  SpecifiedPressure.ResetObserversUptodate;
//  SpecifiedConcTemp.ResetObserversUptodate;
////  Observations.ResetObserversUptodate;
//  Lake.ResetObserversUptodate;
//  GeneralFlowBoundary.ResetObserversUptodate;
//end;

procedure TSutraBoundaries.SetFluidSource(
  const Value: TSutraFluidBoundary);
begin
  FFluidSource.Assign(Value);
end;

procedure TSutraBoundaries.SetGeneralFlowBoundary(
  const Value: TSutraGeneralFlowBoundary);
begin
  FGeneralFlowBoundary.Assign(Value);
end;

procedure TSutraBoundaries.SetGenTransportBoundary(
  const Value: TSutraGeneralTransportBoundary);
begin
  FGenTransportBoundary.Assign(Value);
end;

procedure TSutraBoundaries.SetLake(const Value: TSutraLake);
begin
  FLake.Assign(Value);
end;

procedure TSutraBoundaries.SetMassEnergySource(
  const Value: TSutraMassEnergySourceSinkBoundary);
begin
  FMassEnergySource.Assign(Value);
end;

procedure TSutraBoundaries.SetObservations(const Value: TSutraObservations);
begin
  FObservations.Assign(Value);
end;

procedure TSutraBoundaries.SetSpecifiedConcTemp(
  const Value: TSutraSpecifiedConcTempBoundary);
begin
  FSpecifiedConcTemp.Assign(Value);
end;

procedure TSutraBoundaries.SetSpecifiedPressure(
  const Value: TSutraSpecifiedPressureBoundary);
begin
  FSpecifiedPressure.Assign(Value);
end;

procedure TSutraBoundaries.SetSutraStateObs(
  const Value: TSutraStateObservations);
begin
  FSutraStateObs.Assign(Value);
end;

function TSutraBoundaries.StoreSutraStateObs: Boolean;
begin
  result := SutraStateObs.Used;
end;

end.
