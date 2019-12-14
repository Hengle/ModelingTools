program Mf6ObsExtractor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, OutputFileReader, InputFileReader;

type

  { TMf6ObsExtractor }

  TMf6ObsExtractor = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMf6ObsExtractor }

procedure TMf6ObsExtractor.DoRun;
var
  ErrorMsg: String;
  InputHandler : TInputHandler;
  FileName: string;
  P: PChar;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('hf', ['help', 'file']);
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  FileName := GetOptionValue('f', 'file');
  if Pos('''', FileName) > 0 then
  begin
    P := PChar(FileName);
    FileName := AnsiExtractQuotedStr(P, '''');
  end
  else  if Pos('"', FileName) > 0 then
  begin
    P := PChar(FileName);
    FileName := AnsiExtractQuotedStr(P, '"');
  end;
  if FileName <> '' then
  begin
    if not FileExists(FileName) then
    begin
      WriteLn(FileName, ' was not found.');
      Terminate;
    end;
    WriteLn('Processing ', FileName);
    InputHandler := TInputHandler.Create;
    try
      try
      InputHandler.ReadAndProcessInputFile(FileName);

      Except on E: Exception do
        begin
          WriteLn(E.message);
        end;
      end;
    finally
      InputHandler.Free;
    end;
  end
  else begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor TMf6ObsExtractor.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMf6ObsExtractor.Destroy;
begin
  inherited Destroy;
end;

procedure TMf6ObsExtractor.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h', ' Displays this help message');
  writeln('Usage: ', ExeName, ' -f <filename>', ' processes the filename indicated by <filename>');
  writeln('Usage: ', ExeName, ' -file <filename>', ' processes the filename indicated by <filename>');
end;

var
  Application: TMf6ObsExtractor;
begin
  Application:=TMf6ObsExtractor.Create(nil);
  Application.Title:='MODFLOW 6 Observation Extractor';
  Application.Run;
  Application.Free;
end.
