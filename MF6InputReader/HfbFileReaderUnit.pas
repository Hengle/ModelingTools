unit HfbFileReaderUnit;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, CustomMf6PersistentUnit,
  System.Generics.Collections;

type
  THfbOptions = class(TCustomMf6Persistent)
private
    PRINT_INPUT: Boolean;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  end;

  THfbDimensions = class(TCustomMf6Persistent)
  private
    MAXHFB: Integer;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter);
  protected
    procedure Initialize; override;
  end;

  THfbCellPair = record
    CellId1: TCellId;
    CellId2: TCellId;
    hydchr: Extended;
    procedure Initialize;
  end;

  THfbCellPairList = TList<THfbCellPair>;

  THfbStressPeriod = class(TCustomMf6Persistent)
  private
    IPer: Integer;
    FSettings: THfbCellPairList;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter; Dimensions: TDimensions);
  protected
    procedure Initialize; override;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
  end;

  THfbStressPeriodList = TObjectList<THfbStressPeriod>;

  THfb = class(TDimensionedPackageReader)
  private
    FOptions: THfbOptions;
    FDimensionsHfb: THfbDimensions;
    FStressPeriods: THfbStressPeriodList;
  public
    constructor Create(PackageType: string); override;
    destructor Destroy; override;
    procedure Read(Stream: TStreamReader; Unhandled: TStreamWriter); override;

  end;

implementation

uses
  ModelMuseUtilities;

{ THfbOptions }

procedure THfbOptions.Initialize;
begin
  PRINT_INPUT := False;
  inherited;
end;

procedure THfbOptions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
begin
  Initialize;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'OPTIONS', Unhandled) then
    begin
      Exit
    end;

    ALine := UpperCase(ALine);
    FSplitter.DelimitedText := ALine;
    Assert(FSplitter.Count > 0);
    if FSplitter[0] = 'PRINT_INPUT' then
    begin
      PRINT_INPUT := True;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized HFB option in the following line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ THfbDimensions }

procedure THfbDimensions.Initialize;
begin
  MAXHFB := 0;
  inherited;

end;

procedure THfbDimensions.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
begin
  Initialize;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'DIMENSIONS', Unhandled) then
    begin
      Exit
    end;

    ALine := UpperCase(ALine);
    FSplitter.DelimitedText := ALine;
    Assert(FSplitter.Count > 1);
    if FSplitter[0] = 'MAXHFB' then
    begin

      if not TryStrToInt(FSplitter[1] , MAXHFB) then
      begin
        Unhandled.WriteLine('Invalid value for HFB MAXHFB in the following line.');
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized HFB option in the following line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ THfbStressPeriod }

constructor THfbStressPeriod.Create(PackageType: string);
begin
  FSettings := THfbCellPairList.Create;
  inherited;

end;

destructor THfbStressPeriod.Destroy;
begin
  FSettings.Free;
  inherited;
end;

procedure THfbStressPeriod.Initialize;
begin
  inherited;
  FSettings.Clear;
end;

procedure THfbStressPeriod.Read(Stream: TStreamReader;
  Unhandled: TStreamWriter; Dimensions: TDimensions);
var
  ALine: string;
  ErrorLine: string;
  CellPair: THfbCellPair;
  DimensionCount: Integer;
begin
  DimensionCount := Dimensions.DimensionCount;
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;
    if ReadEndOfSection(ALine, ErrorLine, 'PERIOD', Unhandled) then
    begin
      Exit
    end;

    CellPair.Initialize;

    ALine := UpperCase(ALine);
    FSplitter.DelimitedText := ALine;
    if FSplitter.Count >= DimensionCount*2 + 1 then
    begin
      if ReadCellID(CellPair.CellId1, 0, DimensionCount)
        and ReadCellID(CellPair.CellId1, DimensionCount, DimensionCount)
        and TryFortranStrToFloat(FSplitter[DimensionCount*2], CellPair.hydchr)  then
      begin
        FSettings.Add(CellPair);
      end
      else
      begin
        Unhandled.WriteLine('Unrecognized HFB PERIOD data in the following line.');
        Unhandled.WriteLine(ErrorLine);
      end;
    end
    else
    begin
      Unhandled.WriteLine('Unrecognized HFB PERIOD data in the following line.');
      Unhandled.WriteLine(ErrorLine);
    end;
  end
end;

{ THfb }

constructor THfb.Create(PackageType: string);
begin
  FOptions := THfbOptions.Create(PackageType);
  FDimensionsHfb := THfbDimensions.Create(PackageType);
  FStressPeriods := THfbStressPeriodList.Create;
  inherited;

end;

destructor THfb.Destroy;
begin
  FOptions.Free;
  FDimensionsHfb.Free;
  FStressPeriods.Free;
  inherited;
end;

procedure THfb.Read(Stream: TStreamReader; Unhandled: TStreamWriter);
var
  ALine: string;
  ErrorLine: string;
  IPER: Integer;
  APeriod: THfbStressPeriod;
begin
  while not Stream.EndOfStream do
  begin
    ALine := Stream.ReadLine;
    ErrorLine := ALine;
    ALine := StripFollowingComments(ALine);
    if ALine = '' then
    begin
      Continue;
    end;

    ALine := UpperCase(ALine);
    FSplitter.DelimitedText := ALine;
    if FSplitter[0] = 'BEGIN' then
    begin
      if FSplitter[1] ='OPTIONS' then
      begin
        FOptions.Read(Stream, Unhandled);
      end
      else if FSplitter[1] ='DIMENSIONS' then
      begin
        FDimensionsHfb.Read(Stream, Unhandled);
      end
      else if FSplitter[1] ='PERIOD' then
      begin
        if TryStrToInt(FSplitter[2], IPER) then
        begin
          APeriod := THfbStressPeriod.Create(FPackageType);
          FStressPeriods.Add(APeriod);
          APeriod.IPer := IPER;
          APeriod.Read(Stream, Unhandled, FDimensions);
        end
        else
        begin
          Unhandled.WriteLine('Unrecognized HFB data in the following line.');
          Unhandled.WriteLine(ErrorLine);
        end;
      end
      else
      begin
        Unhandled.WriteLine('Unrecognized HFB data in the following line.');
        Unhandled.WriteLine(ErrorLine);
      end;
    end;
  end;
end;

{ THfbCellPair }

procedure THfbCellPair.Initialize;
begin
  CellId1.Initialize;
  CellId2.Initialize;
  hydchr := 0;
end;

end.