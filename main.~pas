unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tfgame = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type tsentidox = (esquerda, repousox, direita);
type tsentidoy = (cima, repousoy, baixo);
type ttipoanimacao = (explosao1, splash, watertrail, _areia, coin);
type tlocal = (chao, ar, escada, agua, areia, cano);
type ttipobloco = (normal, quicksand, water, pipe);
type ttipocano = (pleft, pdown, pright);

type tcano = record
  fase : string[50];
  y : integer;
  l, c : cardinal;
end;

type tmario = record
  x, y : double;
  sy, sx, accelx : double;
  sentidox, oldsentidox : tsentidox;
  local : tlocal;
  frames, frame : byte;
  frameloading : byte;
  tirodelay : cardinal;
  cano : tcano;
  coins : cardinal;
  max_veloc : byte;
end;

type tcamera = record
  x1, x2 : integer;
  cambmp : tbitmap;
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
end;

type tanimacao = record
  frame, frames: byte;
  tipo : ttipoanimacao;
  ativo: boolean;
  x, y, sx, sy: integer;
end;

type tbolha = record
  x, y : double;
  sy : double;
  larg, alt : byte;
  ativo : boolean;
end;

type tstageinfo = record
  backgroundfile : string[50];
end;

const
  TAM = 32;
  TAM_TILE = 32;

	COL = 200;
  LIN = 15;

  LARG_BUFFER = COL * TAM;
  ALT_BUFFER = LIN * TAM;

  CAM_LIN = LIN;
  CAM_COL = 20;

  LARG_CAM = CAM_COL * TAM;
  ALT_CAM = CAM_LIN * TAM;

  LARG_TELA = 800;
  ALT_TELA = 600;

  MAX_ANIM = 20;

  LARG_MARIO = 32;

  ALT_MARIO = 50;

  MAX_BOLHAS = 100;

  g = 0.3;


var
  fgame: Tfgame;

  mario : tmario;
  camera : tcamera;
  stginfo : tstageinfo;
  
  blocos : array[0..LIN - 1, 0..COL - 1] of tbloco;
  animacoes : array[1..MAX_ANIM] of tanimacao;
  bolhas : array[1..MAX_BOLHAS] of tbolha;

  backbuffer : tbitmap;
  tilesetbmp, tilesetbuffer, tilesetmask, tilesetmask2 : tbitmap;
  mariobmp, mariomaskbmp, mariomask2, mariobuffer : tbitmap;
  coinbmp, coinbuffer, coinmask : tbitmap;
  originalBackgroundFile, backgroundbmp : tbitmap;

  bx : double; // ponteiro do background
  drawcounter, gamecounter, FPS: cardinal;
  scrw, scrh : cardinal;

implementation

{$R *.dfm}

procedure carregarfase(stagename : string);
var
  stagefile : file of tbloco;
  stgInfoFile : file of tstageinfo;
  stgS : string;
  
  b : tbloco;
  
  i, j: cardinal;
begin
	filemode := fmopenread;

  assignfile(stagefile, 'stages\' + stagename);
  reset(stagefile);

  for i := 0 to LIN - 1 do
   	for j := 0 to COL - 1 do
    begin
      read(stagefile, b);
      blocos[i, j] := b;

      blocos[i, j].frame := blocos[i, j].startingFrame;
      blocos[i, j].y := i * TAM;
      blocos[i, j].x := j * TAM;
    end;

  closefile(stagefile);

  stgS := extractfilepath(stagename) + extractfilename(stagename);
  delete(stgS, length(stgS) - 3, 4);
  insert('.sin', stgS, length(stgS) + 1);

  assignfile(stgInfoFile, 'stages\' + stgS);
  reset(stgInfoFile);

  read(stgInfoFile, stginfo);

  closefile(stgInfoFile);


// preparar background
  if stginfo.backgroundfile <> '' then
    originalBackgroundFile.loadfromfile('bitmaps\' + stginfo.backgroundfile)
  else
  begin
    originalBackgroundFile.Assign(nil);
    originalBackgroundFile.Width := LARG_CAM;
    originalBackgroundFile.Height := ALT_CAM;
  end;

  for i := 0 to 2 do
    stretchblt(backgroundbmp.canvas.handle, LARG_CAM * i, 0,
      LARG_CAM, ALT_CAM, originalBackgroundFile.Canvas.Handle, 0, 0, originalBackgroundFile.Width, originalBackgroundFile.height, srccopy);

  bx := LARG_CAM; // coloca o ponteiro da imagem no meio dos tres quadros
end;

procedure reiniciarMario(l, c : cardinal);
begin
  mario.y := l * TAM;
  mario.x := c * TAM;
  mario.sy := 0;
  mario.sx := 0;
  mario.local := ar;
  mario.sentidox := repousox;
  mario.oldsentidox := direita;
  mario.accelx := 0.3;
  mario.max_veloc := 4;
  
  mario.frames := 8;
  mario.frame := 1;

  bx := 0;
  gamecounter := 0;
end;

procedure mudarFase(fase: string; l, c : cardinal);
begin
  carregarFase(fase);
  reiniciarMario(l, c);
end;

procedure morrer;
begin
  mario.x := 100;
  mario.y := 0;
  mario.sy := 0;
  mario.sx := 0;
  mario.sentidox := repousox;
  bx := 0;
end;

procedure dbg(s: string);
begin
	showmessage(s);
end;

procedure animarblocos;
var
  i, j : cardinal;  
begin
  for i := 0 to LIN - 1 do
    for j := ( trunc(camera.x1) div TAM ) to ( trunc(camera.x2) div TAM) do
      if blocos[i, j].animado then
      begin
        if blocos[i, j].tipo = quicksand then
        begin
          if gamecounter mod (6 - (blocos[i, j].parameter)) = 0 then
            if blocos[i, j].frame < blocos[i, j].frames - 1 then
              inc(blocos[i, j].frame)
            else
              blocos[i, j].frame := 0;
        end
        else
          if gamecounter mod 5 = 0 then
            if blocos[i, j].frame < blocos[i, j].frames - 1 then
              inc(blocos[i, j].frame)
            else
              blocos[i, j].frame := 0; 
      end;
end;

function negpos : integer;
var
	i : byte;
begin
	randomize;
   i := random(2);

   if i = 0 then result := -1
   else result := 1;
end;

procedure inserirBolha(x, y : double);
var
  i : cardinal;
begin
  randomize;
  for i := 1 to MAX_BOLHAS do
    if not bolhas[i].ativo then
    begin
      bolhas[i].ativo := true;
      bolhas[i].x := x;
      bolhas[i].y := y;
      bolhas[i].sy := (0.5 + random(3) / 10); 
      bolhas[i].larg := 1 + random(3);
      bolhas[i].alt := 1 + random(3);
      break;
    end;
end;

procedure animarbolhas;
var
  i : cardinal;
begin
  for i := 1 to MAX_BOLHAS do
    if bolhas[i].ativo then
    begin
      bolhas[i].y := bolhas[i].y - bolhas[i].sy;
      if (bolhas[i].y <= 0) or (blocos[trunc(bolhas[i].y) div TAM, trunc(bolhas[i].x) div TAM].tipo <> water) then
        bolhas[i].ativo := false;
    end;
end;

procedure atualizaranimacoes();
var
	i: integer;
begin

	if gamecounter mod 5 = 0 then
   begin
   	for i := 1 to MAX_ANIM do
			if animacoes[i].ativo then
         begin
          animacoes[i].x := animacoes[i].x + animacoes[i].sx;
          animacoes[i].y := animacoes[i].y + animacoes[i].sy;
      		if animacoes[i].frame < animacoes[i].frames then
         		Inc(animacoes[i].frame)
         	else
         		animacoes[i].ativo := false;
         end;
   end;

end;


procedure inseriranimacao(x, y, sx, sy: double; tipo: ttipoanimacao);
var
	i: integer;
begin;
	for i := 1 to MAX_ANIM do
   begin
   	if animacoes[i].ativo = false then
      begin
        animacoes[i].tipo := tipo;
        animacoes[i].ativo := true;
        animacoes[i].frame := 1;
        animacoes[i].x := trunc(x);
        animacoes[i].y := trunc(y);
        animacoes[i].sx := trunc(sx);
        animacoes[i].sy := trunc(sy);


        case tipo of
          explosao1: animacoes[i].frames := 16;
          watertrail, _areia : animacoes[i].frames := 5;
          coin : animacoes[i].frames := 4;
        end;
        break;
      end;
   end;
end;

procedure desenhar(x, y : double; bmp : tbitmap);
begin
	backbuffer.canvas.draw(trunc(x), trunc(y), bmp);
end;

procedure desenharcenario;
var
	i, j : cardinal;
begin

  //desenhar background
  bitblt(backbuffer.Canvas.Handle, camera.x1, 0, LARG_CAM, ALT_CAM, backgroundbmp.canvas.handle, round(bx), 0, srccopy);

  // desenhar blocos que ficam atraz do mario
	for i := 0 to LIN - 1 do
   	for j := ( trunc(camera.x1) div TAM ) to ( trunc(camera.x2) div TAM) do
      if not blocos[i, j].frente then
      begin
        bitblt(backbuffer.canvas.handle, blocos[i, j].x, blocos[i, j].y, TAM, TAM, tilesetmask2.canvas.handle, blocos[i, j].tilesheetcol * TAM_TILE + blocos[i, j].frame * TAM_TILE, blocos[i, j].tilesheetrow * TAM_TILE, srcand);
        bitblt(backbuffer.canvas.handle, blocos[i, j].x, blocos[i, j].y, TAM, TAM, tilesetbuffer.canvas.handle, blocos[i, j].tilesheetcol * TAM_TILE + blocos[i, j].frame * TAM_TILE, blocos[i, j].tilesheetrow * TAM_TILE, srcpaint);
      end;


  case mario.local of
    chao, ar, areia, cano:
      if mario.oldsentidox = esquerda then
      begin
        if (mario.local = ar) or (mario.sy < 0) then
        begin
          stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO + 2, mariomask2.canvas.handle, 20, 34, 20, 36, srcand);
          stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO + 2, mariobuffer.canvas.handle, 20, 34, 20, 36, srcpaint);
        end
        else
        begin
          if mario.sx = 0 then
          begin
            stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, 0, 70, 19, 34, srcand);
            stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, 0, 70, 19, 34, srcpaint);
          end
          else
          begin
            if mario.sx <= -4.5 then
            begin
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO + 5, ALT_MARIO, mariomask2.canvas.handle, (mario.frame - 1) * 25 + 1, 176, 23, 32, srcand);
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO + 5, ALT_MARIO, mariobuffer.canvas.handle, (mario.frame - 1) * 25 + 1, 176, 23, 32, srcpaint);
            end
            else
            begin
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, (mario.frame - 1) * 23, 70, 19, 32, srcand);
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, (mario.frame - 1) * 23, 70, 19, 32, srcpaint);
            end;
          end;
        end
      end
      else if mario.oldsentidox = direita then
      begin
        if (mario.local = ar) or (mario.sy < 0) then
        begin
          stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO + 2, mariomask2.canvas.handle, 0, 34, 20, 36, srcand);
          stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO + 2, mariobuffer.canvas.handle, 0, 34, 20, 36, srcpaint);
        end
        else
        begin
          if mario.sx = 0 then
          begin
            stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, 160, 0, 20, 33, srcand);
            stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, 160, 0, 20, 33, srcpaint);
          end
          else
          begin
            if mario.sx >= 4.5 then
            begin
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO + 5, ALT_MARIO, mariomask2.canvas.handle, (mario.frame - 1) * 25 + 1, 140, 23, 32, srcand);
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO + 5, ALT_MARIO, mariobuffer.canvas.handle, (mario.frame - 1) * 25 + 1, 140, 23, 32, srcpaint);
            end
            else
            begin
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, (mario.frame - 1) * 23, 0, 19, 32, srcand);
              stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, (mario.frame - 1) * 23, 0, 19, 32, srcpaint);
            end;
          end;
          end
      end;

    agua:
      if mario.oldsentidox = esquerda then
      begin
        stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, 77 + (mario.frame - 1) * 23, 103, 23, 34, srcand);
        stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, 77 + (mario.frame - 1) * 23, 103, 23, 34, srcpaint);
      end
      else if mario.oldsentidox = direita then
      begin
        stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariomask2.canvas.handle, (mario.frame - 1) * 23 + 1, 103, 22, 34,srcand);
        stretchblt(backbuffer.canvas.handle, trunc(mario.x), trunc(mario.y), LARG_MARIO, ALT_MARIO, mariobuffer.canvas.handle, (mario.frame - 1) * 23 + 1, 103, 22, 34,srcpaint);
      end;
  end;


  //desenhar blocos que ficam na frente do mario
  for i := 0 to LIN - 1 do
   	for j := ( trunc(camera.x1) div TAM ) to ( trunc(camera.x2) div TAM) do
      if blocos[i, j].frente then
      begin
        bitblt(backbuffer.canvas.handle, blocos[i, j].x, blocos[i, j].y, TAM, TAM, tilesetmask2.canvas.handle, blocos[i, j].tilesheetcol * TAM_TILE + blocos[i, j].frame * TAM_TILE, blocos[i, j].tilesheetrow * TAM_TILE, srcand);
        bitblt(backbuffer.canvas.handle, blocos[i, j].x, blocos[i, j].y, TAM, TAM, tilesetbuffer.canvas.handle, blocos[i, j].tilesheetcol * TAM_TILE + blocos[i, j].frame * TAM_TILE, blocos[i, j].tilesheetrow * TAM_TILE, srcpaint);
      end;

   for i:= 1 to MAX_ANIM do
      if animacoes[i].ativo then
         case animacoes[i].tipo of
            explosao1: begin end;
            coin:
            begin
              bitblt(coinbuffer.canvas.handle, 0, 0, coinbuffer.width, coinbuffer.height, coinmask.canvas.handle, 0, 0, srccopy);
              bitblt(backbuffer.canvas.handle, animacoes[i].x, animacoes[i].y, 32, 32, coinbuffer.canvas.handle, (animacoes[i].frame - 1) * 32, 0, srcand);
              bitblt(coinbuffer.canvas.handle, 0, 0, coinbuffer.width, coinbuffer.height, coinbmp.canvas.handle, 0, 0, srcerase);
              bitblt(backbuffer.canvas.handle, animacoes[i].x, animacoes[i].y, 32, 32, coinbuffer.canvas.handle, (animacoes[i].frame - 1) * 32, 0, srcpaint);
            end;
         end;

  for i := 1 to MAX_BOLHAS do
    if bolhas[i].ativo then
    begin
      backbuffer.Canvas.Rectangle(trunc(bolhas[i].x), trunc(bolhas[i].y), trunc(bolhas[i].x) + bolhas[i].larg, trunc(bolhas[i].y) + bolhas[i].alt);
    end;

   
   //backbuffer.Canvas.TextOut(trunc(mario.x),trunc(mario.y)-10,inttostr(mario.frame));
end;

procedure setscreenres(const width, height, colorDepth : integer); overload;
var
	mode:TDevMode;
begin
  zeroMemory(@mode, sizeof(TDevMode));
	mode.dmSize := sizeof(TDevMode);
  mode.dmPelsWidth := width;
  mode.dmPelsHeight := height;
  mode.dmBitsPerPel := colorDepth;
  mode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL;
  ChangeDisplaySettings(mode, 0);
end;

procedure iniciarbitmaps;
begin
  originalBackgroundFile := tbitmap.create;
  originalbackgroundfile.Canvas.brush.color := clskyblue;
  backgroundbmp := tbitmap.create;
  backgroundbmp.width := 3 * LARG_CAM;
  backgroundbmp.height := ALT_CAM;

  tilesetbmp := tbitmap.create;
  tilesetbmp.LoadFromFile('bitmaps\tileset.bmp');

  tilesetbuffer := tbitmap.create;
  tilesetbuffer.width := tilesetbmp.width;
  tilesetbuffer.height := tilesetbmp.height;

  tilesetmask := tbitmap.create;
  tilesetmask.assign(tilesetbmp);
  tilesetmask.Mask(rgb(255, 0, 255));

  tilesetmask2 := tbitmap.create;
  tilesetmask2.width := tilesetmask.width;
  tilesetmask2.Height := tilesetmask.height;

  bitblt(tilesetmask2.canvas.handle, 0, 0, tilesetmask.width, tilesetmask.height, tilesetmask.canvas.handle, 0, 0, srccopy);
  bitblt(tilesetbuffer.canvas.handle, 0, 0, tilesetbuffer.width, tilesetbuffer.height, tilesetmask.canvas.handle, 0, 0, srccopy);
  bitblt(tilesetbuffer.canvas.handle, 0, 0, tilesetbuffer.width, tilesetbuffer.height, tilesetbmp.canvas.handle, 0, 0, srcerase);
  

	backbuffer := tbitmap.create;
  backbuffer.width := TAM * COL;
  backbuffer.Height := TAM * LIN;
  backbuffer.canvas.font.color:=clwhite;
  backbuffer.canvas.pen.style := psclear;
  backbuffer.canvas.Brush.Color := clskyblue;
  //backbuffer.canvas.brush.color := clblack;

  camera.cambmp := tbitmap.create;
  camera.cambmp.Width := LARG_CAM;
  camera.cambmp.height := ALT_CAM;
  camera.cambmp.canvas.font.color := clwhite;
  camera.cambmp.Canvas.Brush.color:=clnavy;


// mario
  mariobmp := tbitmap.create;
  mariobmp.LoadFromFile('bitmaps\mario.bmp');

  mariomaskbmp := tbitmap.create;
  mariomaskbmp.assign(mariobmp);
  mariomaskbmp.mask(rgb(255, 0, 255));

  mariomask2 := tbitmap.create;
  mariomask2.width := mariomaskbmp.width;
  mariomask2.height := mariomaskbmp.height;

  mariobuffer := tbitmap.create;
  mariobuffer.width := mariobmp.Width;
  mariobuffer.Height := mariobmp.height;

  bitblt(mariobuffer.canvas.handle, 0, 0, mariobuffer.width, mariobuffer.height, mariomaskbmp.canvas.handle, 0, 0, srccopy);
  bitblt(mariomask2.canvas.handle, 0, 0, mariomaskbmp.width, mariomaskbmp.height, mariomaskbmp.canvas.handle, 0, 0, srccopy);
  bitblt(mariobuffer.canvas.handle, 0, 0, mariobuffer.width, mariobuffer.height, mariobmp.canvas.handle, 0, 0, srcerase);


// animacoes
  coinbmp := tbitmap.Create;
  coinbmp.LoadFromFile('bitmaps\coin.bmp');

  coinbuffer := tbitmap.create;
  coinbuffer.width := coinbmp.Width;
  coinbuffer.Height := coinbmp.height;

  coinmask := tbitmap.create;
  coinmask.Assign(coinbmp);
  coinmask.Mask(rgb(255, 0, 255));
end;

procedure Tfgame.FormCreate(Sender: TObject);
begin

   width := LARG_TELA + 6;
   height := ALT_TELA + 24;

   scrw := screen.width;
   scrh := screen.Height;
  //setscreenres(800, 600, 16);

end;

procedure Tfgame.FormDestroy(Sender: TObject);
begin
  originalBackgroundFile.free;
  backgroundbmp.free;

	tilesetbmp.free;
  tilesetbuffer.free;
  tilesetmask.free;
  tilesetmask2.free;

	backbuffer.Free;
  camera.cambmp.Free;

  mariobmp.free;
  mariomaskbmp.free;
  mariomask2.free;
  mariobuffer.Free;

  coinbmp.free;
  coinbuffer.free;
  coinmask.free;

  //setscreenres(scrw, scrh, 16);
end;

procedure movercamera;
begin
  if mario.x + (LARG_MARIO div 2) - LARG_CAM div 2 <= 0 then
    camera.x1 := 0
  else
    camera.x1 := trunc(mario.x) + (LARG_MARIO div 2) - LARG_CAM div 2;

  if mario.x + (LARG_MARIO div 2) + LARG_CAM div 2 > COL * TAM then
  begin
   	camera.x2 := COL * TAM;
    camera.x1 := COL * TAM - LARG_CAM;
  end
  else if mario.x + (LARG_MARIO div 2) - LARG_CAM div 2 <= 0 then
   	camera.x2 := LARG_CAM
  else
    camera.x2 := trunc(mario.x) + (LARG_MARIO div 2) + LARG_CAM div 2;

  if (camera.x1 <> 0) and (camera.x2 <> LARG_BUFFER) then
  begin
    bx := bx + (mario.sx / 8);
    if mario.sentidox = direita then
    begin
      if bx >= 2 * LARG_CAM then
        bx := LARG_CAM;
    end
    else if mario.sentidox = esquerda then
    begin
      if bx <= 0 then
        bx := LARG_CAM;
    end;
  end;
end;

procedure lerteclado;
begin
	if getkeystate(vk_escape) < 0 then application.Terminate;
	if getkeystate(vk_left) < 0 then
  begin
    mario.oldsentidox := esquerda;
    mario.sentidox := esquerda;
  end
  else if getkeystate(vk_right) < 0 then
  begin
    mario.sentidox := direita;
    mario.oldsentidox := direita;
  end
  else mario.sentidox := repousox;

  if getkeystate($41) < 0 then
  begin
    if not (mario.local = ar) then
      mario.max_veloc := 7;
  end
  else
    mario.max_veloc := 4;

  if getkeystate(vk_down) < 0 then
    if blocos[trunc(mario.y) div TAM + 2, trunc(mario.x) div TAM].tipo = pipe then
    begin
      mario.cano := blocos[trunc(mario.y) div TAM + 2, trunc(mario.x) div TAM].cano;
      mario.local := cano;  
      mario.sx := 0;    
    end;

  if getkeystate(vk_up) < 0 then
  begin
    
  end;
  
  if getkeystate(90) < 0 then
    case mario.local of
      chao:
      begin
        if mario.sy >= 0 then
        begin
          mario.local := ar;
          mario.sy:= -8;
        end;
      end;

      areia:
      begin
        if mario.sy >= 0 then mario.sy := -1;
      end;

      agua:
      begin
        if mario.sy >= 0 then
        begin
          if blocos[trunc(mario.y) div TAM, trunc(mario.x) div TAM].tipo = normal then mario.sy := -6
          else mario.sy := mario.sy - 3;
          inserirbolha(mario.x, mario.y);
        end;

        if abs(mario.sx) < 3 then
        begin
          if mario.sentidox = esquerda then
            mario.sx := mario.sx - 3
          else if mario.sentidox = direita then
            mario.sx := mario.sx + 3;
        end;
      end;
    end;
end;


procedure checarLocal;
var
	l, c : integer;
begin
  l := trunc(mario.y) div TAM;
  c := trunc(mario.x) div TAM;

  // quando o mario estiver dentro de um cano, a funcao sai, pois a funcao que controla o movimento dentro do cano e "moverMario()"
  if mario.local = cano then exit;
  
  if ( (blocos[l + 2, c].tipo = quicksand) ) then
  begin
    if not (mario.local = areia) then
    begin
      mario.sy := 0;
      inseriranimacao(trunc(mario.x), trunc(mario.y) + ALT_MARIO, 0, 0, _areia);
    end;
    mario.local := areia;
    mario.frames := 8;
  end
  else if (blocos[l + 1, c].tipo = water) then
  begin
    if not (mario.local = agua) then
    begin
      mario.sy := mario.sy / 6;
      mario.sx := 0;
    end;
    mario.local := agua;
    mario.frames := 3;
  end
  else if ( (blocos[l + 2, c].solido12h) and (mario.y + ALT_MARIO >= blocos[l + 2, c].y))
    or ( (blocos[l + 2, c + 1].solido12h) and (mario.x + LARG_MARIO > blocos[l + 2, c + 1].x) and (mario.y + ALT_MARIO >= blocos[l + 2, c].y) )
    or (blocos[l + 2, c + 1].leftslope)
    or (blocos[l + 1, c + 1].leftslope)
    or (blocos[l + 1, c].rightslope)
    or (blocos[l + 2, c].rightslope) then
  begin
    mario.local := chao;
    if abs(mario.sx) >= 4.5 then
      mario.frames := 6
    else
      mario.frames := 8;
  end
  else
  begin
    mario.local := ar;
    mario.frames := 8;
  end;

end;

procedure movermario;
var
  l, c : integer;
  novox, novoy : double;
begin
  checarLocal;

  case mario.local of
    ar, chao:
    begin
      if mario.sentidox = esquerda then
      begin
        if mario.sx > -mario.max_veloc then mario.sx := mario.sx - mario.accelx
        else if mario.sx < -mario.max_veloc then mario.sx := mario.sx + mario.accelx;
      end
      else if mario.sentidox = direita then
      begin
        if mario.sx < mario.max_veloc then
          mario.sx := mario.sx + mario.accelx
        else if mario.sx > mario.max_veloc then mario.sx := mario.sx - mario.accelx;
      end
      else begin
        if mario.local = ar then
        begin
           if mario.sx > 0 then mario.sx := mario.sx - 0.25 * mario.accelx
           else if mario.sx < 0 then mario.sx := mario.sx + 0.25 * mario.accelx;
          if abs(mario.sx) <= 0.25  * mario.accelx then mario.sx := 0;
        end
        else if mario.local = chao then
        begin
          if mario.sx > 0 then mario.sx := mario.sx - 0.5 * mario.accelx
           else if mario.sx < 0 then mario.sx := mario.sx + 0.5 * mario.accelx;
           if abs(mario.sx) <= 0.25  * mario.accelx then mario.sx := 0;
        end;
      end;

      if mario.local = ar then
        mario.sy := mario.sy + g;       
    end;

    areia:
    begin
      case blocos[trunc(mario.y) div TAM + 2, trunc(mario.x) div TAM].parameter of
        0 : if mario.sy < 0.4 then mario.sy := mario.sy + 0.1;
        1 : if mario.sy < 0.8 then mario.sy := mario.sy + 0.1;
        2 : if mario.sy < 1.25 then mario.sy := mario.sy + 0.25;
      end;

      if mario.sentidox = esquerda then
        mario.sx := -0.5
      else if mario.sentidox = direita then
        mario.sx := 0.5
      else
      begin
        if mario.sx < 0 then
          mario.sx := mario.sx + 0.1
        else if mario.sx > 0 then
          mario.sx := mario.sx - 0.1;
        if abs(mario.sx) < 0.5 then
          mario.sx := 0;
      end;
    end;

    agua:
    begin
      if mario.sy < 0.6 then mario.sy := mario.sy + 0.1;

      if mario.sentidox = esquerda then
      begin
        if mario.sx > -1 then
          mario.sx := mario.sx - 0.25;
      end
      else if mario.sentidox = direita then
      begin
        if mario.sx < 1 then
          mario.sx := mario.sx + 0.25;
      end;
      //else
      begin
        if mario.sx < 0 then
          mario.sx := mario.sx + 0.05
        else if mario.sx > 0 then
          mario.sx := mario.sx - 0.05;
        if abs(mario.sx) < 0.2 then
          mario.sx := 0;
      end;

      if gamecounter mod 10 = 0 then
      begin
        if mario.oldsentidox = direita then
        begin
          inserirbolha(mario.x + LARG_MARIO - 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + LARG_MARIO - 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + LARG_MARIO - 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + LARG_MARIO - 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
        end
        else
        begin
          inserirbolha(mario.x + 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
          inserirbolha(mario.x + 10 + negpos * random(5), mario.y + 20 + negpos * random(5));
        end;
            
      end;
    end;

    cano:
    begin
      mario.y := mario.y + 1;
      if mario.y - mario.cano.y >= 5 then
      begin
        mudarFase(mario.cano.fase, mario.cano.l, mario.cano.c);
      end;
      exit;
    end;

  end;


// colisoes
  novox := mario.x + mario.sx;

  if novox + LARG_MARIO >= LARG_BUFFER then
  begin
    novox := LARG_BUFFER - LARG_MARIO;
    mario.sx := 0;
  end;

  if novox <= 0 then 
  begin
    novox := 0;
    mario.sx := 0;
  end;
    
  l := trunc(mario.y) div TAM; // proximo bloco
  c := trunc(novox) div TAM;

  if mario.sx < 0 then
  begin    
    if ( (blocos[l + 2, c].solido3h) and (mario.y + ALT_MARIO > blocos[l + 2, c].y) ) or (blocos[l + 1, c].solido3h) or (blocos[l, c].solido3h) then
    begin        
      novox := blocos[l + 1, c].x + TAM;
      mario.sx := 0;
    end;
  end
  else if mario.sx > 0 then
  begin
    if ( (blocos[l + 2, c + 1].solido9h) and (mario.y + ALT_MARIO > blocos[l + 2, c + 1].y) ) or (blocos[l + 1, c + 1].solido9h) or (blocos[l, c + 1].solido9h) then
    begin
      novox := blocos[l, c + 1].x - LARG_MARIO;
      mario.sx := 0;
    end;
  end;


  novoy := mario.y + mario.sy;

  if novoy <= 0 then 
  begin
    novoy := 0;
    mario.sy := 0;
  end
  else if novoy + 2 * TAM >= ALT_BUFFER then
  begin
    morrer;
    exit;
  end;

  l := trunc(novoy) div TAM;
  c := trunc(novox) div TAM;

  if mario.sy < 0 then
  begin    
    if ( (blocos[l, c + 1].solido6h) and (novox + LARG_MARIO > blocos[l, c + 1].x) ) or (blocos[l, c].solido6h) then
    begin
      novoy := blocos[l, c + 1].y + TAM;
      mario.sy := 2;
      if ((blocos[l, c + 1].coin) and (novox + LARG_MARIO > blocos[l, c + 1].x) ) then
      begin
        blocos[l, c + 1].tilesheetrow := 4;
        blocos[l, c + 1].tilesheetcol := 3;
        inseriranimacao(blocos[l, c + 1].x, blocos[l, c + 1].y - 32, 0, -20, coin);
        blocos[l, c + 1].coin := false;
        blocos[l, c + 1].animado := false;
        blocos[l, c + 1].frame := 0;
        blocos[l, c + 1].frames := 1;
      end;
      if (blocos[l, c].coin) and (mario.x <= (blocos[l, c].x + TAM) - 10) then
      begin
        blocos[l, c].tilesheetrow := 4;
        blocos[l, c].tilesheetcol := 3;
        inseriranimacao(blocos[l, c].x, blocos[l, c].y - 32, 0, -20, coin);
        blocos[l, c].coin := false;
        blocos[l, c].animado := false;
        blocos[l, c].frame := 0;
        blocos[l, c].frames := 1;
      end;
      // added this part for breakable blocks. might contain a bug and need to be analuyzed better
      if ((blocos[l, c + 1].quebravel) and (novox + LARG_MARIO > blocos[l, c + 1].x) ) then
      begin
        blocos[l, c + 1].tilesheetrow := 0;
        blocos[l, c + 1].tilesheetcol := 0;
        blocos[l, c + 1].animado := false;
        blocos[l, c + 1].frame := 0;
        blocos[l, c + 1].frames := 1;
        blocos[l, c + 1].quebravel := false;
      end;
      if (blocos[l, c].quebravel) and (mario.x <= (blocos[l, c].x + TAM) - 10) then
      begin
        blocos[l, c].tilesheetrow := 0;
        blocos[l, c].tilesheetcol := 0;
        blocos[l, c].frame := 0;
        blocos[l, c].frames := 1;
        blocos[l, c].quebravel := false;
        blocos[l, c].animado := false;
      end;
      // end of breakable blocks code
    end;
  end
  else if mario.sy > 0 then
  begin
    if ( (blocos[l + 2, c + 1].solido12h) and (novox + LARG_MARIO > blocos[l + 2, c + 1].x) and (novoy + ALT_MARIO > blocos[l + 2, c + 1].y) )
    or ( (blocos[l + 2, c].solido12h) and (novoy + ALT_MARIO > blocos[l + 2, c].y) ) then
    begin        
      novoy := blocos[l + 2, c + 1].y - ALT_MARIO;
      mario.sy := 0;
    end;
  end;

  //checar declives pela esquerda

  if (blocos[l + 1, c + 1].leftslope) and not ( mario.sy < 0 ) then
  begin
      novoy := blocos[l + 1, c + 1].y + TAM - ( novox + LARG_MARIO - blocos[l + 1, c + 1].x ) - ALT_MARIO;
      mario.sy := 0;
  end
  else if (blocos[l + 2, c + 1].leftslope) and not ( mario.sy < 0 ) then
  begin
    novoy := blocos[l + 2, c + 1].y + TAM - ( novox + LARG_MARIO - blocos[l + 2, c + 1].x ) - ALT_MARIO;
    mario.sy := 0;
  end;
  
// declives pela direita
  if (blocos[l + 1, c].rightslope) and not ( mario.sy < 0 ) then
  begin
      novoy := ( blocos[l + 1, c].y + TAM - ( blocos[l + 1, c].x + TAM - novox ) ) - ALT_MARIO;
      mario.sy := 0;
  end
  else if (blocos[l + 2, c].rightslope) and not ( mario.sy < 0 ) then
  begin
      novoy := ( blocos[l + 2, c].y + TAM - ( blocos[l + 2, c].x + TAM - novox ) ) - ALT_MARIO;
      mario.sy := 0;
  end;
// ----------

   if mario.frameloading = 0 then
   begin
     if mario.frame < mario.frames then
      inc(mario.frame)
     else
      mario.frame := 1;

     if (mario.local = agua) or (mario.local = areia) then
      mario.frameloading := 6
     else
      mario.frameloading := 8 - abs(trunc(mario.sx));
   end;

   if (mario.sx <> 0) or (mario.local = agua) then dec(mario.frameloading);


   mario.x := novox;
   mario.y := novoy;
end;

procedure desenharcamera;
begin
	bitblt(camera.cambmp.canvas.handle, 0, 0, trunc(camera.x2 - camera.x1), ALT_CAM, backbuffer.canvas.handle, trunc(camera.x1), 0, srccopy);

  camera.cambmp.canvas.textout(0, 20, floattostr((mario.sx) ));
  camera.cambmp.canvas.textout(0, 50, inttostr(mario.frame));
   
  camera.cambmp.canvas.textout(0, 40, floattostr((trunc(mario.y)) div TAM ));
  camera.cambmp.canvas.textout(0, 60, inttostr(trunc(mario.x) div TAM));
end;

procedure desenhartela;
begin
	stretchblt(fgame.canvas.handle, 0, 0, LARG_TELA, ALT_TELA, camera.cambmp.canvas.handle, 0, 0, LARG_CAM, ALT_CAM, srccopy);
end;



procedure Tfgame.FormActivate(Sender: TObject);
var
	oldcount : cardinal;
begin

  iniciarbitmaps;
 
  reiniciarMario(1, 1);
	carregarFase('stage1.stg');
  
  oldcount := gettickcount;

  camera.cambmp.canvas.Brush.style := bsclear;
  camera.cambmp.Canvas.Font.color := clyellow;

  while not application.Terminated do
  begin
    if gettickcount - oldcount < 15 then continue;
      lerteclado();
      moverMario();

      atualizaranimacoes();
      animarbolhas;
      movercamera();
      desenharcenario;
      desenharcamera();

      if mario.sy < 0 then camera.cambmp.canvas.Textout(0,0,'up')
      else if mario.sy > 0 then camera.cambmp.canvas.TextOut(0,0,'down');

      if mario.local = ar then camera.cambmp.canvas.Textout(30,0,'ar')
      else if mario.local = chao then camera.cambmp.canvas.TextOut(30,0,'chao')
      else if mario.local = areia then camera.cambmp.canvas.TextOut(30,0,'areia')
      else if mario.local = agua then camera.cambmp.canvas.TextOut(30,0,'agua')
      else if mario.local = cano then camera.cambmp.canvas.TextOut(30,0,'cano');
      camera.cambmp.Canvas.TextOut(70, 0, floattostr(mario.sy));
      camera.cambmp.Canvas.TextOut(300,0,'FPS:'+inttostr(FPS));
      camera.cambmp.Canvas.TextOut(400,0,'bx:'+floattostr(bx));
      camera.cambmp.Canvas.TextOut(500,0,'frames:' +inttostr(mario.frames));

      desenhartela();
      animarBlocos();
      inc(gamecounter);


      oldcount := gettickcount;
      inc(drawcounter);
      application.ProcessMessages;
  end;
end;

procedure Tfgame.Timer1Timer(Sender: TObject);
begin
	FPS := drawcounter;
  drawcounter := 0;
end;

end.
