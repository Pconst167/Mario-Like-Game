program mario;

uses
  Forms,
  main in 'main.pas' {fgame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Super Mario Bros';
  Application.CreateForm(Tfgame, fgame);
  Application.Run;
end.
