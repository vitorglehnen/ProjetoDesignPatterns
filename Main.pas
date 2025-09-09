unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ColorGrd,

  System.Generics.Collections,
  Model.Shapes,
  Editor.Canvas,
  Patterns.Commands, Vcl.Imaging.pngimage;

type
  TFormMain = class(TForm)
    pnlToolbar: TPanel;
    btnAddCircle: TButton;
    btnAddRectangle: TButton;
    btnUndo: TButton;
    cbColor: TColorBox;
    pbCanvas: TPaintBox;
    imgUnivates: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddCircleClick(Sender: TObject);
    procedure btnAddRectangleClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure pbCanvasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbCanvasPaint(Sender: TObject);
  private
    FDrawingCanvas: TDrawingCanvas;
    FCirclePrototype: TCircle;
    FRectanglePrototype: TRectangle;
    FCommandHistory: TStack<ICommand>;
    FShapeToAddNext: TShape;
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // Inicializa todos os nossos objetos principais
  FDrawingCanvas := TDrawingCanvas.Create;
  FCommandHistory := TStack<ICommand>.Create;

  // Cria os prot�tipos que ser�o clonados
  FCirclePrototype := TCircle.Create;
  FRectanglePrototype := TRectangle.Create;

  FShapeToAddNext := nil;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FDrawingCanvas.Free;
  FCommandHistory.Free;
  FCirclePrototype.Free;
  FRectanglePrototype.Free;
  FShapeToAddNext.Free;
end;

procedure TFormMain.btnAddCircleClick(Sender: TObject);
begin
  FShapeToAddNext.Free;
  FShapeToAddNext := FCirclePrototype.Clone;
  FShapeToAddNext.Color := cbColor.Selected;
  Self.Caption := 'Editor de Formas - Clique na tela para adicionar um c�rculo';
end;

procedure TFormMain.btnAddRectangleClick(Sender: TObject);
begin
  FShapeToAddNext.Free;
  FShapeToAddNext := FRectanglePrototype.Clone;
  FShapeToAddNext.Color := cbColor.Selected;
  Self.Caption := 'Editor de Formas - Clique na tela para adicionar um ret�ngulo';
end;

procedure TFormMain.btnUndoClick(Sender: TObject);
var
  LastCommand: ICommand;
begin
  // Verifica se h� algo para desfazer
  if FCommandHistory.Count > 0 then
  begin
    // Pega o �ltimo comando da pilha
    LastCommand := FCommandHistory.Pop;

    // Manda o comando se "desfazer"
    LastCommand.UnExecute;

    // Redesenha a tela para mostrar o estado anterior
    pbCanvas.Invalidate;
    Self.Caption := 'Editor de Formas - A��o desfeita!';
  end;
end;

procedure TFormMain.pbCanvasMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Command: ICommand;
begin
  // S� faz algo se o usu�rio j� tiver clicado em adicionar c�rculo/ret�ngulo
  if not Assigned(FShapeToAddNext) then
    Exit;

  // Posiciona a nova forma onde o usu�rio clicou
  FShapeToAddNext.X := X - (FShapeToAddNext.Width div 2);
  FShapeToAddNext.Y := Y - (FShapeToAddNext.Height div 2);

  // Cria o objeto de comando para esta a��o
  Command := TAddShapeCommand.Create(FDrawingCanvas, FShapeToAddNext);

  // Executa o comando
  Command.Execute;

  // Adiciona o comando � nossa pilha de hist�rico (para o undo)
  FCommandHistory.Push(Command);

  // Limpa a vari�vel para que o pr�ximo clique n�o adicione outra forma
  FShapeToAddNext := nil;

  // For�a a tela a se redesenhar com a nova forma
  pbCanvas.Invalidate;
  Self.Caption := 'Projeto de Demonstra��o de Design Patterns';
end;

procedure TFormMain.pbCanvasPaint(Sender: TObject);
begin
  FDrawingCanvas.DrawAll(pbCanvas.Canvas);
end;

end.
