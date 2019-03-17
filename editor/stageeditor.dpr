program stageeditor;

uses
  Forms,
  editor in 'editor.pas' {feditor},
  rowcol in 'rowcol.pas' {frmRowCol};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Stage Editor';
  Application.CreateForm(Tfeditor, feditor);
  Application.CreateForm(TfrmRowCol, frmRowCol);
  Application.Run;
end.
