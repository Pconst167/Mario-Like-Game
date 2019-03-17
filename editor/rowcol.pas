unit rowcol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmRowCol = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtLin: TEdit;
    edtCol: TEdit;
    Button1: TButton;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRowCol: TfrmRowCol;

implementation

uses editor;

{$R *.dfm}

procedure TfrmRowCol.Button1Click(Sender: TObject);
begin
  editor.blocos[feditor.geditor.Row, feditor.geditor.col].cano.l := strtoint(edtLin.text);
  editor.blocos[feditor.geditor.Row, feditor.geditor.col].cano.c := strtoint(edtCol.text);
  close;
end;

procedure TfrmRowCol.FormShow(Sender: TObject);
begin
  edtLin.SetFocus;
end;

end.
