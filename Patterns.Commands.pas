unit Patterns.Commands;

interface

uses
  System.SysUtils,
  Editor.Canvas,
  Model.Shapes;

type
  // Qualquer ação no nosso sistema como adicionar, mover, deletar pode implementar esta interface.
  ICommand = interface
    ['{B93D211F-4B17-4820-998C-084F93B8640C}']
    procedure Execute;
    procedure UnExecute;
  end;

  TAddShapeCommand = class(TInterfacedObject, ICommand)
  private
    FDrawingCanvas: TDrawingCanvas;
    FShapeToAdd: TShape;
    FMemento: TCanvasMemento;
  public
    constructor Create(ADrawingCanvas: TDrawingCanvas; AShapeToAdd: TShape);
    destructor Destroy; override;

    procedure Execute;
    procedure UnExecute;
  end;

implementation

{ TAddShapeCommand }

constructor TAddShapeCommand.Create(ADrawingCanvas: TDrawingCanvas;
  AShapeToAdd: TShape);
begin
  FDrawingCanvas := ADrawingCanvas;
  FShapeToAdd := AShapeToAdd;
  FMemento := nil;
end;

destructor TAddShapeCommand.Destroy;
begin
  FMemento.Free;
  inherited;
end;

procedure TAddShapeCommand.Execute;
begin
  // Antes de executar a ação, salvamos o estado atual do canvas, o Memento é a nossa "foto" do antes.
  FMemento := FDrawingCanvas.CreateMemento;

  FDrawingCanvas.AddShape(FShapeToAdd);
end;

procedure TAddShapeCommand.UnExecute;
begin
  // Para desfazer, simplesmente restauramos o canvas para o estado que salvamos no Memento antes da execução.
  if Assigned(FMemento) then
  begin
    FDrawingCanvas.RestoreFromMemento(FMemento);
  end;
end;

end.
