unit frameScreenObjectAddedDemandRunoffSplitUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameScreenObjectCustomFmp4BoundaryUnit,
  Vcl.Grids, RbwDataGrid4, Vcl.StdCtrls, ArgusDataEntry, Vcl.Buttons, Vcl.Mask,
  JvExMask, JvSpin, Vcl.ExtCtrls, UndoItemsScreenObjects, ModflowFmp4BoundaryUnit;

type
  TframeScreenObjectAddedDemandRunoffSplit = class(TframeScreenObjectCustomFmp4Boundary)
  private
    { Private declarations }
  protected
    function GetValueDescription: string; override;
    function GetBoundary(Item: TScreenObjectEditItem): TFmp4Boundary; override;
    function CreateBoundary: TFmp4Boundary; override;
  public
    { Public declarations }
  end;

var
  frameScreenObjectAddedDemandRunoffSplit: TframeScreenObjectAddedDemandRunoffSplit;

implementation

uses ModflowFmp4AddedDemandRunoffSplitUnit;

{$R *.dfm}

{ TframeScreenObjectAddedDemandRunoffSplit }

function TframeScreenObjectAddedDemandRunoffSplit.CreateBoundary: TFmp4Boundary;
begin
  result := TFmp4AddedDemandRunoffSplitBoundary.Create(nil, nil);
end;

function TframeScreenObjectAddedDemandRunoffSplit.GetBoundary(
  Item: TScreenObjectEditItem): TFmp4Boundary;
begin
  result := Item.ScreenObject.Fmp4AddedDemandRunoffSplitBoundary
end;

function TframeScreenObjectAddedDemandRunoffSplit.GetValueDescription: string;
begin
  result := TFmp4AddedDemandRunoffSplitBoundary.ValueDescription;
end;

end.
