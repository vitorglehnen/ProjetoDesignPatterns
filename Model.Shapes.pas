unit Model.Shapes;

interface

uses
  System.Classes, System.UITypes, Vcl.Graphics;

type
  // Classe base para todas as formas. Funciona como um contrato.
  TShape = class(TPersistent)
  private
    FX: Integer;
    FY: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FColor: TColor;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

    // O método principal do padrão PROTOTYPE. Ele cria uma cópia exata do objeto atual.
    function Clone: TShape; virtual; abstract;

    // Método para desenhar a forma em uma tela
    procedure Draw(ACanvas: TCanvas); virtual; abstract;

    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Color: TColor read FColor write FColor;
  end;

  // Implementação concreta de um Círculo
  TCircle = class(TShape)
  public
    function Clone: TShape; override;
    procedure Draw(ACanvas: TCanvas); override;
  end;

  // Implementação concreta de um Retângulo
  TRectangle = class(TShape)
  public
    function Clone: TShape; override;
    procedure Draw(ACanvas: TCanvas); override;
  end;

implementation

{ TShape }

constructor TShape.Create;
begin
  inherited;

  FWidth  := 50;
  FHeight := 50;
  FColor  := clBlack;
end;

procedure TShape.Assign(Source: TPersistent);
var
  SourceShape: TShape;
begin
  if Source is TShape then
  begin
    SourceShape := TShape(Source);
    Self.FX := SourceShape.FX;
    Self.FY := SourceShape.FY;
    Self.FWidth := SourceShape.FWidth;
    Self.FHeight := SourceShape.FHeight;
    Self.FColor := SourceShape.FColor;
  end
  else
    inherited;
end;


{ TCircle }

function TCircle.Clone: TShape;
var
  NewCircle: TCircle;
begin
  NewCircle := TCircle.Create;
  NewCircle.Assign(Self);
  Result := NewCircle;
end;

procedure TCircle.Draw(ACanvas: TCanvas);
begin
  ACanvas.Brush.Color := Self.Color;
  ACanvas.Pen.Color := clBlack;
  ACanvas.Ellipse(Self.X, Self.Y, Self.X + Self.Width, Self.Y + Self.Height);
end;

{ TRectangle }

function TRectangle.Clone: TShape;
var
  NewRectangle: TRectangle;
begin
  NewRectangle := TRectangle.Create;
  NewRectangle.Assign(Self);
  Result := NewRectangle;
end;

procedure TRectangle.Draw(ACanvas: TCanvas);
begin
  ACanvas.Brush.Color := Self.Color;
  ACanvas.Pen.Color := clBlack;
  ACanvas.Rectangle(Self.X, Self.Y, Self.X + Self.Width, Self.Y + Self.Height);
end;

end.
