unit editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, Menus, StdCtrls, Buttons, jpeg, Tabs, ComCtrls,
  TabNotBk, ExtDlgs, Spin;

type
  Tfeditor = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Newstage1: TMenuItem;
    Loadstage1: TMenuItem;
    Savestage1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    tilesetMenu: TPopupMenu;
    Drawinselectedarea1: TMenuItem;
    dlgopen: TOpenDialog;
    dlgsave: TSaveDialog;
    Makethisareasolid1: TMenuItem;
    Makethisareanonsolid1: TMenuItem;
    N3: TMenuItem;
    Makethisareasolidontop1: TMenuItem;
    Makebottomsolid1: TMenuItem;
    Makeallsurfacessolid1: TMenuItem;
    N4: TMenuItem;
    Makeallsurfacesnonsolid1: TMenuItem;
    Fillselectedareaonsolid1: TMenuItem;
    N6: TMenuItem;
    Clearselectedarea1: TMenuItem;
    dlgopenpic: TOpenPictureDialog;
    N5: TMenuItem;
    Breakable1: TMenuItem;
    Unbreakable1: TMenuItem;
    N7: TMenuItem;
    Pasteselection1: TMenuItem;
    Pasteselectionnonsolid1: TMenuItem;
    N8: TMenuItem;
    Slopefromtheleft1: TMenuItem;
    Slopefromtheright1: TMenuItem;
    Straight1: TMenuItem;
    N9: TMenuItem;
    Quicksand1: TMenuItem;
    Normal1: TMenuItem;
    Water1: TMenuItem;
    High1: TMenuItem;
    Normal2: TMenuItem;
    Slowsinking1: TMenuItem;
    N10: TMenuItem;
    Front1: TMenuItem;
    Back1: TMenuItem;
    N11: TMenuItem;
    Pipeleadingintostage1: TMenuItem;
    Coinblock1: TMenuItem;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    imgBackgroundPreview: TImage;
    Button1: TButton;
    Image2: TImage;
    Panel1: TPanel;
    geditor: TDrawGrid;
    Splitter1: TSplitter;
    imgpreview: TImage;
    lblSelRowE: TLabel;
    lblSelRowEv: TLabel;
    lblSelColEv: TLabel;
    lblSelColE: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    gtileset: TDrawGrid;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure gtilesetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure geditorDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure gtilesetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Drawinselectedarea1Click(Sender: TObject);
    procedure Makeallsurfacessolid1Click(Sender: TObject);
    procedure Makethisareasolid1Click(Sender: TObject);
    procedure Makeallsurfacesnonsolid1Click(Sender: TObject);
    procedure Makethisareanonsolid1Click(Sender: TObject);
    procedure Makethisareasolidontop1Click(Sender: TObject);
    procedure Makebottomsolid1Click(Sender: TObject);
    procedure geditorSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Savestage1Click(Sender: TObject);
    procedure Loadstage1Click(Sender: TObject);
    procedure Newstage1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Fillselectedareaonsolid1Click(Sender: TObject);
    procedure Clearselectedarea1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure geditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Breakable1Click(Sender: TObject);
    procedure Unbreakable1Click(Sender: TObject);
    procedure Pasteselection1Click(Sender: TObject);
    procedure Pasteselectionnonsolid1Click(Sender: TObject);
    procedure Slopefromtheleft1Click(Sender: TObject);
    procedure Slopefromtheright1Click(Sender: TObject);
    procedure Straight1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Water1Click(Sender: TObject);
    procedure High1Click(Sender: TObject);
    procedure Normal2Click(Sender: TObject);
    procedure Slowsinking1Click(Sender: TObject);
    procedure Front1Click(Sender: TObject);
    procedure Back1Click(Sender: TObject);
    procedure Pipeleadingintostage1Click(Sender: TObject);
    procedure Coinblock1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  COL = 200;
  LIN = 15;
  TAM = 32;

  TAM_TILE = 32;


type tsentidoy = (cima, repousoy, baixo);
type ttipobloco = (normal, quicksand, water, pipe);

type tcano = record
  fase : string[50];
  y : integer;
  l, c : cardinal;
end;

type tstageinfo = record
  backgroundfile : string[50];
end;

type tbloco = record
  tipo: ttipobloco;
	x, y : integer;
  quebravel, leftslope, rightslope : boolean;
  solido12h, solido6h, solido3h, solido9h : boolean;
  tilesheetrow, tilesheetcol : cardinal;
  animado : boolean;
  frame, frames, startingFrame : byte;
  parameter : byte;
  frente : boolean;
  cano : tcano;
  coin : boolean;
  impulso : boolean;
end;

var
  feditor: Tfeditor;
  blocos : array[0..LIN - 1, 0..COL - 1] of tbloco;
  tilesetbmp : tbitmap;
  stageinfo : tstageinfo;

  filename : string;

  selectedTileRow, selectedTileCol : cardinal;

  SelectedEnmType : Byte;

implementation

uses rowcol;

{$R *.dfm}

procedure Tfeditor.FormCreate(Sender: TObject);
begin
	tilesetbmp := tbitmap.create;
  tilesetbmp.LoadFromFile('..\bitmaps\tileset.bmp');

  gtileset.RowCount := tilesetbmp.Height div TAM_TILE;
  gtileset.colCount := tilesetbmp.width div TAM_TILE;

  geditor.RowCount := LIN;
  geditor.colCount := COL;

  stretchblt(imgpreview.canvas.handle, 0, 0, 65, 65, tilesetbmp.canvas.handle, 0, 0, TAM_TILE, TAM_TILE, srccopy);
end;

procedure Tfeditor.FormDestroy(Sender: TObject);
begin
	tilesetbmp.free;
end;

procedure Tfeditor.Front1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
        blocos[i, j].frente := true;
      end;
   geditor.Refresh;
end;

procedure Tfeditor.Exit1Click(Sender: TObject);
begin
   close;
end;


procedure Tfeditor.gtilesetDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
	stretchblt(gtileset.canvas.Handle, rect.left, rect.top, TAM, TAM, tilesetbmp.canvas.Handle, acol * TAM_TILE, arow * TAM_TILE, TAM_TILE, TAM_TILE, srccopy);
end;

procedure Tfeditor.geditorDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
	stretchblt(geditor.canvas.handle, rect.left, rect.top, 32, 32, tilesetbmp.canvas.handle, blocos[arow, acol].tilesheetcol * TAM_TILE, blocos[arow, acol].tilesheetrow * TAM_TILE, TAM_TILE, TAM_TILE, srccopy);

  { for i := 1 to MAX_ENMSOURCE do
   	if (enmsource[i].row = arow) and (enmsource[i].col = acol) then
      	stretchblt(geditor.canvas.handle, rect.Left, rect.Top, 32, 32, imgenm1.Canvas.handle, 0, 0, 31, 41, srccopy);
            
   if (blocos[arow, acol].solido12h) or (blocos[arow, acol].solido3h) or (blocos[arow, acol].solido6h) or (blocos[arow, acol].solido9h) then
   	geditor.Canvas.textout(acol * 32 + 13, arow * 32, 's');
   if blocos[arow, acol].quebravel then
   	geditor.Canvas.textout(acol * 32 + 13, arow * 32 + 10, 'b');
    
   if blocos[arow, acol].leftslope then
   	geditor.Canvas.textout(acol * 32 + 13, arow * 32 + 20, 'ls')
   else if blocos[arow, acol].rightslope then
   	geditor.Canvas.textout(acol * 32 + 13, arow * 32 + 20, 'rs');

   if (blocos[arow, acol].tipo = quicksand) then
   	geditor.Canvas.textout(acol * 32, arow * 32, 'qs');  }
end;

procedure Tfeditor.gtilesetSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  selectedTileRow := arow;
  selectedTileCol := acol;

  stretchblt(imgpreview.canvas.Handle, 0, 0, imgpreview.width, imgpreview.height, tilesetbmp.canvas.Handle, acol * TAM_TILE, arow * TAM_TILE, TAM_TILE, TAM_TILE, srccopy);
  imgpreview.Refresh;

  label3.caption := inttostr(arow);
  label4.caption := inttostr(acol);
end;

procedure Tfeditor.High1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
    begin
      blocos[i, j].tipo := quicksand;
      blocos[i, j].parameter := 2;
    end;

   geditor.Refresh;
end;

procedure Tfeditor.Drawinselectedarea1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].tilesheetrow := selectedTileRow;
         blocos[i, j].tilesheetcol := selectedTileCol;
         blocos[i, j].solido12h := true;
         blocos[i, j].solido3h := true;
         blocos[i, j].solido6h := true;
         blocos[i, j].solido9h := true;
      end;
      
   geditor.Refresh;
end;

procedure Tfeditor.Makeallsurfacessolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := true;
         blocos[i, j].solido3h := true;
         blocos[i, j].solido6h := true;
         blocos[i, j].solido9h := true;
      end;

   geditor.Refresh;
end;

procedure Tfeditor.Makethisareasolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := false;
         blocos[i, j].solido3h := false;
         blocos[i, j].solido6h := false;
         blocos[i, j].solido9h := true;
      end;
   geditor.Refresh;
end;

procedure Tfeditor.Makeallsurfacesnonsolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := false;
         blocos[i, j].solido3h := false;
         blocos[i, j].solido6h := false;
         blocos[i, j].solido9h := false;
      end;
	geditor.Refresh;
end;

procedure Tfeditor.Makethisareanonsolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := false;
         blocos[i, j].solido3h := true;
         blocos[i, j].solido6h := false;
         blocos[i, j].solido9h := false;
      end;
   geditor.Refresh;
end;

procedure Tfeditor.Makethisareasolidontop1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := true;
         blocos[i, j].solido3h := false;
         blocos[i, j].solido6h := false;
         blocos[i, j].solido9h := false;
      end;
   geditor.Refresh;
end;

procedure Tfeditor.Makebottomsolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].solido12h := false;
         blocos[i, j].solido3h := false;
         blocos[i, j].solido6h := true;
         blocos[i, j].solido9h := false;
      end;
   geditor.Refresh;
end;

procedure Tfeditor.geditorSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
	if blocos[arow, acol].solido9h then
   	label5.Caption := 'Solid on the left: Yes'
   else
   	label5.caption := 'Solid on the left: No';
   if blocos[arow, acol].solido3h then
   	label6.Caption := 'Solid on the right: Yes'
   else
   	label6.caption := 'Solid on the right: No';
   if blocos[arow, acol].solido12h then
   	label7.Caption := 'Solid on top: Yes'
   else
   	label7.caption := 'Solid on top: No';
   if blocos[arow, acol].solido6h then
   	label8.Caption := 'Solid on bottom: Yes'
   else
   	label8.caption := 'Solid on bottom: No';

   lblSelRowEv.Caption := inttostr(ARow);
   lblSelColEv.Caption := inttostr(ACol);
end;

procedure Tfeditor.Savestage1Click(Sender: TObject);
var
	stageFile :  file of tbloco;
  stgInfoFile : file of tstageinfo;
  stgS : string;
  i, j : cardinal;
begin
	if filename = '' then
  begin
		if dlgsave.Execute then
   	begin
      assignfile(stageFile, dlgsave.FileName);
      rewrite(stageFile);

      for i := 0 to LIN - 1 do
        for j := 0 to COL - 1 do
          write(stageFile, blocos[i, j]);

      filename := dlgsave.filename;
      feditor.caption := 'Stage Editor - ' + filename;

      closefile(stageFile);

      stgS := extractfilepath(filename) + extractfilename(filename);
      delete(stgS, length(stgS) - 3, 4);
      insert('.sin', stgS, length(stgS) + 1);

      assignfile(stgInfoFile, stgS);
      rewrite(stgInfoFile);

      write(stgInfoFile, stageinfo);

      closefile(stgInfoFile);
    end
  end
  else
  begin
    assignfile(stageFile, filename);
    rewrite(stageFile);

    for i := 0 to LIN - 1 do
      for j := 0 to COL - 1 do
        write(stageFile, blocos[i, j]);

    closefile(stageFile);

    stgS := extractfilepath(filename) + extractfilename(filename);
    delete(stgS, length(stgS) - 3, 4);
    insert('.sin', stgS, length(stgS) + 1);

    assignfile(stgInfoFile, stgS);
    rewrite(stgInfoFile);

    write(stgInfoFile, stageinfo);

    closefile(stgInfoFile);
  end;
end;

procedure Tfeditor.Slopefromtheleft1Click(Sender: TObject);
begin
  blocos[geditor.row, geditor.col].leftslope := true;
  blocos[geditor.row, geditor.col].rightslope := false;
end;

procedure Tfeditor.Slopefromtheright1Click(Sender: TObject);
begin
  blocos[geditor.row, geditor.col].leftslope := false;
  blocos[geditor.row, geditor.col].rightslope := true;
end;

procedure Tfeditor.Slowsinking1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
    begin
      blocos[i, j].tipo := quicksand;
      blocos[i, j].parameter := 0;
    end;

   geditor.Refresh;
end;

procedure Tfeditor.Straight1Click(Sender: TObject);
begin
  blocos[geditor.row, geditor.col].leftslope := false;
  blocos[geditor.row, geditor.col].rightslope := false;
end;

procedure Tfeditor.Loadstage1Click(Sender: TObject);
var
	stageFile :  file of tbloco;
  stgInfoFile : file of tstageinfo;
  stgS : string;
  
  i, j : cardinal;
  b : tbloco;
begin
	if dlgopen.Execute then
  begin
   	filemode := fmOpenRead;
    
   	assignfile(stageFile, dlgopen.filename);
    reset(stageFile);

    for i := 0 to LIN - 1 do
      for j := 0 to COL - 1 do
      begin
        read(stageFile, b);
        blocos[i, j] := b;
      end;

    filename := dlgopen.filename;
    feditor.caption := 'Stage Editor - ' + filename;

    closefile(stageFile);

    stgS := extractfilepath(filename) + extractfilename(filename);
    delete(stgS, length(stgS) - 3, 4);
    insert('.sin', stgS, length(stgS) + 1);

    assignfile(stgInfoFile, stgS);
    reset(stgInfoFile);

    read(stgInfoFile, stageinfo);

    closefile(stgInfoFile);

    if stageinfo.backgroundfile <> '' then
      imgbackgroundpreview.Picture.Bitmap.loadfromfile('..\bitmaps\' + stageinfo.backgroundfile)
    else
      imgbackgroundpreview.Picture.Bitmap.assign(nil);
  end;

   geditor.Refresh;
end;

procedure Tfeditor.Newstage1Click(Sender: TObject);
var
	i, j : cardinal;
begin
	for i := 0 to LIN - 1 do
   	for j := 0 to COL - 1 do
      begin
        blocos[i, j].tipo := normal;
        blocos[i, j].cano.fase := '';
        blocos[i, j].cano.l := 0;
        blocos[i, j].cano.c := 0;
      	blocos[i, j].quebravel := false;
      	blocos[i, j].tilesheetrow := 0;
        blocos[i, j].tilesheetcol := 0;
        blocos[i, j].solido12h := false;
        blocos[i, j].solido3h := false;
        blocos[i, j].solido6h := false;
        blocos[i, j].solido9h := false;
        blocos[i, j].leftslope := false;
        blocos[i, j].rightslope := false;
        blocos[i, j].animado := false;
        blocos[i, j].frames := 1;
        blocos[i, j].startingFrame := 0;

        stageinfo.backgroundfile := '';
        imgbackgroundpreview.Picture.Bitmap.Assign(nil);
      end;

   geditor.refresh;

   filename := '';
   feditor.caption := 'Stage Editor - New stage';
end;

procedure Tfeditor.Normal1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      	blocos[i, j].tipo := normal;

   geditor.Refresh;
end;

procedure Tfeditor.Normal2Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
    begin
      blocos[i, j].tipo := quicksand;
      blocos[i, j].parameter := 1;
    end;

   geditor.Refresh;
end;

procedure Tfeditor.Saveas1Click(Sender: TObject);
var
  stageFile :  file of tbloco;
  stgInfoFile : file of tstageinfo;
  stgS : string;

  i, j : cardinal;
begin
  if dlgsave.Execute then
  begin
    assignfile(stageFile, dlgsave.FileName);
    rewrite(stageFile);

    for i := 0 to LIN - 1 do
       for j := 0 to COL - 1 do
          write(stageFile, blocos[i, j]);

    filename := dlgsave.FileName;
    feditor.caption := 'Stage Editor - ' + filename;
    closefile(stageFile);

    stgS := extractfilepath(filename) + extractfilename(filename);
    delete(stgS, length(stgS) - 3, 4);
    insert('.sin', stgS, length(stgS) + 1);

    assignfile(stgInfoFile, stgS);
    rewrite(stgInfoFile);

    write(stgInfoFile, stageinfo);

    closefile(stgInfoFile);
	end;
end;

procedure Tfeditor.Fillselectedareaonsolid1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
      	blocos[i, j].tilesheetrow := selectedTileRow;
         blocos[i, j].tilesheetcol := selectedTileCol;
         blocos[i, j].solido12h := false;
         blocos[i, j].solido3h := false;
         blocos[i, j].solido6h := false;
         blocos[i, j].solido9h := false;
      end;
      
   geditor.Refresh;
end;

procedure Tfeditor.Clearselectedarea1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
  i2 := geditor.Selection.bottom;
  j1 := geditor.Selection.left;
  j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
        blocos[i, j].tipo := normal;
        blocos[i, j].cano.fase := '';
        blocos[i, j].cano.l := 0;
        blocos[i, j].cano.c := 0;
        blocos[i, j].tilesheetrow := 0;
        blocos[i, j].tilesheetcol := 0;
        blocos[i, j].quebravel := false;
        blocos[i, j].solido12h := false;
        blocos[i, j].solido3h := false;
        blocos[i, j].solido6h := false;
        blocos[i, j].solido9h := false;
        blocos[i, j].leftslope := false;
        blocos[i, j].rightslope := false;
        blocos[i, j].animado := false;
        blocos[i, j].frames := 1;
        blocos[i, j].startingFrame := 0;
      end;

   geditor.Refresh;
end;

procedure Tfeditor.Coinblock1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
  i2 := geditor.Selection.bottom;
  j1 := geditor.Selection.left;
  j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
        if not blocos[i, j].coin then
          blocos[i, j].coin := true
        else
          blocos[i, j].coin := false;

   geditor.Refresh;
end;

procedure Tfeditor.Button1Click(Sender: TObject);
begin
	if dlgopenpic.Execute then
   begin
      imgBackgroundpreview.Picture.Bitmap.LoadFromFile(dlgopenpic.filename);
      stageinfo.backgroundfile := extractfilename(dlgopenpic.filename);
   end;
end;

procedure Tfeditor.Back1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      begin
        blocos[i, j].frente := false;
      end;
      
   geditor.Refresh;
end;

procedure Tfeditor.BitBtn1Click(Sender: TObject);
begin
	selectedEnmType := 1;
end;

procedure Tfeditor.geditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
  i1 := geditor.Selection.Top;
  i2 := geditor.Selection.bottom;
  j1 := geditor.Selection.left;
  j2 := geditor.Selection.right;


  case key of
    $31:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].animado := false;
              blocos[i, j].startingFrame := 0;
              blocos[i, j].frames := 1;
            end;
    $32:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].animado := true;
              blocos[i, j].startingFrame := 0;
              blocos[i, j].frames := 2;
            end;
    $33:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].animado := true;
              blocos[i, j].startingFrame := 0;
              blocos[i, j].frames := 3;
            end;
    $34:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].animado := true;
              blocos[i, j].startingFrame := 0;
              blocos[i, j].frames := 4;
            end;
    $35:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].animado := true;
              blocos[i, j].startingFrame := 0;
              blocos[i, j].frames := 5;
            end;

    46: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              blocos[i, j].tipo := normal;
              blocos[i, j].solido12h := false;
              blocos[i, j].solido3h := false;
              blocos[i, j].solido6h := false;
              blocos[i, j].solido9h := false;
              blocos[i, j].tilesheetrow := 0;
              blocos[i, j].tilesheetcol := 0;
              blocos[i, j].leftslope := false;
              blocos[i, j].rightslope := false;
              blocos[i, j].animado := false;
              blocos[i, j].frames := 1;
              blocos[i, j].startingFrame := 0;
            end;

    87: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              if blocos[i, j].solido12h then
                blocos[i, j].solido12h := false
              else
                blocos[i, j].solido12h := true;
            end;

    83: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              if blocos[i, j].solido6h then
                blocos[i, j].solido6h := false
              else
                blocos[i, j].solido6h := true;
            end;
    65: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              if blocos[i, j].solido9h then
                blocos[i, j].solido9h := false
              else
                blocos[i, j].solido9h := true;
            end;
    68: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              if blocos[i, j].solido3h then
                blocos[i, j].solido3h := false
              else
                blocos[i, j].solido3h := true;
            end;
    69: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              blocos[i, j].solido12h := true;
              blocos[i, j].solido3h := true;
              blocos[i, j].solido6h := true;
              blocos[i, j].solido9h := true;
            end;
    81: for i := i1 to i2 do
          for j := j1 to j2 do
            begin
              blocos[i, j].solido12h := false;
              blocos[i, j].solido3h := false;
              blocos[i, j].solido6h := false;
              blocos[i, j].solido9h := false;
            end;
    $5A:  for i := i1 to i2 do     // Z
            for j := j1 to j2 do
              begin
                blocos[i, j].tilesheetrow := selectedtileRow;
                blocos[i, j].tilesheetCol := selectedtileCol;
                blocos[i, j].solido12h := false;
                blocos[i, j].solido3h := false;
                blocos[i, j].solido6h := false;
                blocos[i, j].solido9h := false;
              end;
    $58:  for i := i1 to i2 do     // X
            for j := j1 to j2 do
              begin
                blocos[i, j].tilesheetrow := selectedtileRow;
                blocos[i, j].tilesheetCol := selectedtileCol;
                blocos[i, j].solido12h := true;
                blocos[i, j].solido3h := true;
                blocos[i, j].solido6h := true;
                blocos[i, j].solido9h := true;
              end;

    $43:  for i := gtileset.Selection.top to gtileset.Selection.Bottom do
            for j := gtileset.Selection.Left to gtileset.selection.Right do
                if (i1 + i - gtileset.selection.top >= 0)
                 and (i1 + i - gtileset.selection.top < LIN)
                 and (j1 + j - gtileset.selection.left >= 0)
                 and (j1 + j - gtileset.selection.left < COL) then
                begin
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].tilesheetrow := i;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].tilesheetcol := j;

                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido12h := false;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido3h := false;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido6h := false;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido9h := false;
                end;
    $56:  for i := gtileset.Selection.top to gtileset.Selection.Bottom do
            for j := gtileset.Selection.Left to gtileset.selection.Right do
                if (i1 + i - gtileset.selection.top >= 0)
                 and (i1 + i - gtileset.selection.top < LIN)
                 and (j1 + j - gtileset.selection.left >= 0)
                 and (j1 + j - gtileset.selection.left < COL) then
                begin
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].tilesheetrow := i;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].tilesheetcol := j;

                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido12h := true;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido3h := true;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido6h := true;
                    blocos[i1 + i - gtileset.selection.top, j1 + j - gtileset.selection.left].solido9h := true;
                end;
    $42:  for i := i1 to i2 do  // B
            for j := j1 to j2 do
              begin
                blocos[i, j].leftslope := true;
                blocos[i, j].rightslope := false;
              end;
    $4E:  for i := i1 to i2 do  // N
            for j := j1 to j2 do
              begin
                blocos[i, j].leftslope := false;
                blocos[i, j].rightslope := false;
              end;
    $4D:  for i := i1 to i2 do // M
            for j := j1 to j2 do
              begin
                blocos[i, j].leftslope := false;
                blocos[i, j].rightslope := true;
              end;
    $52:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].tipo := quicksand;
              blocos[i, j].parameter := 0;
            end;
    $54:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].tipo := quicksand;
              blocos[i, j].parameter := 1;
            end;
    $59:  for i := i1 to i2 do
            for j := j1 to j2 do
            begin
              blocos[i, j].tipo := quicksand;
              blocos[i, j].parameter := 2;
            end;
    $46:  for i := i1 to i2 do
            for j := j1 to j2 do
              blocos[i, j].tipo := water;
  end;

  geditor.Refresh;    
end;

procedure Tfeditor.Breakable1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      	blocos[i, j].quebravel := true;

   geditor.Refresh;
end;

procedure Tfeditor.Unbreakable1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      	blocos[i, j].quebravel := false;

   geditor.Refresh;
end;

procedure Tfeditor.Water1Click(Sender: TObject);
var
	i, j, i1, i2, j1, j2 : cardinal;
begin
	i1 := geditor.Selection.Top;
   i2 := geditor.Selection.bottom;
   j1 := geditor.Selection.left;
   j2 := geditor.Selection.right;

	for i := i1 to i2 do
   	for j := j1 to j2 do
      	blocos[i, j].tipo := water;

   geditor.Refresh;
end;

procedure Tfeditor.Pasteselection1Click(Sender: TObject);
var
	i, j : cardinal;
begin
	for i := gtileset.Selection.top to gtileset.Selection.Bottom do
   	for j := gtileset.Selection.Left to gtileset.selection.Right do
      	if (geditor.selection.top + i - gtileset.selection.top >= 0)
         and (geditor.selection.top + i - gtileset.selection.top < LIN)
         and (geditor.selection.left + j - gtileset.selection.left >= 0)
         and (geditor.selection.left + j - gtileset.selection.left < COL) then
      	begin
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].tilesheetrow := i;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].tilesheetcol := j;

            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido12h := true;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido3h := true;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido6h := true;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido9h := true;
      	end;

   geditor.Refresh;
end;

procedure Tfeditor.Pasteselectionnonsolid1Click(Sender: TObject);
var
	i, j : cardinal;
begin
	for i := gtileset.Selection.top to gtileset.Selection.Bottom do
   	for j := gtileset.Selection.Left to gtileset.selection.Right do
      	if (geditor.selection.top + i - gtileset.selection.top >= 0)
         and (geditor.selection.top + i - gtileset.selection.top < LIN)
         and (geditor.selection.left + j - gtileset.selection.left >= 0)
         and (geditor.selection.left + j - gtileset.selection.left < COL) then
         begin
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].tilesheetrow := i;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].tilesheetcol := j;

            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido12h := false;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido3h := false;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido6h := false;
            blocos[geditor.selection.top + i - gtileset.selection.top, geditor.selection.left + j - gtileset.selection.left].solido9h := false;
      	end;

   geditor.Refresh;
end;

procedure Tfeditor.Pipeleadingintostage1Click(Sender: TObject);
begin
  if dlgOpen.execute then
  begin
    blocos[geditor.Row, geditor.col].tipo := pipe;
    blocos[geditor.Row, geditor.col].cano.y := geditor.Row * TAM;
    blocos[geditor.Row, geditor.Col].cano.fase := extractfilename(dlgOpen.FileName);

    frmRowCol.showmodal;
  end;
end;

end.
