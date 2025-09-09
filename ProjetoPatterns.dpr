program ProjetoPatterns;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  Model.Shapes in 'Model.Shapes.pas',
  Editor.Canvas in 'Editor.Canvas.pas',
  Patterns.Commands in 'Patterns.Commands.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
