unit uIpsumControls;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.Graphics,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Dialogs;

type
  TIpsumButton = class(TPanel)
    private
      FCaption         : String;
      FCaptionDestaque : String;
      FIconSize        : Integer;
      FImageList       : TImageList;
      FImageIndex      : Integer;
      FLabelBotao      : TLabel;
      FFont            : TFont;
      FColor,
      FHotColor        : TColor;
      FButtonClick     : TNotifyEvent;
      FAlignment       : TAlignment;
      FDown            : Boolean;
      FMouseEnter      : TNotifyEvent;
      FMouseLeave      : TNotifyEvent;
      procedure FontChanged(Sender: TObject);
      procedure ButtonClick(Sender: TObject);
      procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
      procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
      procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure DrawIcon;
    protected
      procedure SetFont(Value: TFont);
      function  GetCaption: String;
      procedure SetCaption(Value: String);
      procedure Resize; override;
      procedure DoButtonClick; virtual;
      procedure SetAlignment(Value: TAlignment);
      procedure SetDown(Value: Boolean);
      procedure DoEnter; override;
      procedure DoExit; override;
      procedure DoMouseEnter; virtual;
      procedure DoMouseLeave; virtual;
      procedure SetHotColor(Value: TColor);
      procedure SetImageIndex(const Value: Integer);
      procedure SetIconSize(const Value: Integer);
      procedure SetImageList(const Value: TImageList);
      procedure Paint; override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
      procedure   Click; override;
    published
      property Alignment    : TAlignment   read FAlignment       write SetAlignment default taLeftJustify;
      property Caption      : String       read GetCaption       write SetCaption;
      property Font         : TFont        read FFont            write SetFont;
      property OnClick      : TNotifyEvent read FButtonClick     write FButtonClick;
      property OnMouseEnter                read FMouseEnter      write FMouseEnter;
      property OnMouseLeave                read FMouseLeave      write FMouseLeave;
      property Down         : Boolean      read FDown            write SetDown;
      property HotColor     : TColor       read FHotColor        write SetHotColor default $00DF8B00;
      property ImageList    : TImageList   read FImageList       write SetImageList default nil;
      property ImageIndex   : Integer      read FImageIndex      write SetImageIndex default -1;
      property IconSize     : Integer      read FIconSize        write SetIconSize default 32;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Ipsum Controls', [TIpsumButton]);
end;

{ TIpsumButton }

procedure TIpsumButton.ButtonClick(Sender: TObject);
begin
  DoButtonClick;
end;

procedure TIpsumButton.Click;
begin
  DoButtonClick;
end;

procedure TIpsumButton.CMColorChanged(var Message: TMessage);
begin
  inherited;

  if Color <> FHotColor then
    FColor := Color;
end;

procedure TIpsumButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  DoMouseEnter;
end;

procedure TIpsumButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  DoMouseLeave;
end;

constructor TIpsumButton.Create(AOwner: TComponent);
  function IpsumButtonCount: Integer;
  var
    i,
    vCount: Integer;
  begin
    vCount := 0;

    for i := 0 to Pred(AOwner.ComponentCount) do
      if AOwner.Components[i] is TIpsumButton then
        Inc(vCount);

    Result := vCount;
  end;
begin
  inherited Create(AOwner);

  FFont           := TFont.Create;
  Font.Color      := clWhite;
  Self.BevelOuter := bvNone;
  FImageIndex     := -1;
  FIconSize       := 32;
  FImageList      := nil;

  FLabelBotao               := TLabel.Create(Self);
  FLabelBotao.Parent        := Self;
  FLabelBotao.Align         := alNone;
  FLabelBotao.Layout        := tlCenter;
  FLabelBotao.AutoSize      := False;
  FLabelBotao.Font.Color    := clBlack;
  FLabelBotao.Caption       := Self.Caption;
  FLabelBotao.Top           := 0;
  FLabelBotao.WordWrap      := True;

  Self.ShowCaption          := False;

  FLabelBotao.Height        := Self.Height;

  FHotColor                 := $00D57A00;
  Self.Color                := $009F5B00;

  FLabelBotao.Left          := FIconSize + 20;
  FLabelBotao.Width         := Self.Width - FIconSize - 3;

  FFont.OnChange         := FontChanged;
  Brush.Color            := Color;

  Self.Caption           := Copy(ClassName + IntToStr(IpsumButtonCount), 2, Length(ClassName + IntToStr(IpsumButtonCount)) -1);

  FLabelBotao.OnClick    := ButtonClick;

  Alignment              := taLeftJustify;
  FLabelBotao.Alignment  := Alignment;
end;

destructor TIpsumButton.Destroy;
begin
  FreeAndNil(FLabelBotao);

  inherited Destroy;
end;

procedure TIpsumButton.DoButtonClick;
begin
  if Assigned(FButtonClick) then
    FButtonClick(Self);
end;

procedure TIpsumButton.DoEnter;
begin
  inherited DoEnter;
  setDown(True);

  Self.SetFocus;
end;

procedure TIpsumButton.DoExit;
begin
  inherited DoExit;
  setDown(False);
end;

procedure TIpsumButton.DoMouseEnter;
begin
  if Assigned(FMouseEnter) then
    FMouseEnter(Self);

  Self.Color  := FHotColor;
  Brush.Color := FHotColor;

  Invalidate;
end;

procedure TIpsumButton.DoMouseLeave;
begin
  if Assigned(FMouseLeave) then
    FMouseLeave(Self);

  Self.Color  := FColor;
  Brush.Color := FColor;

  Invalidate;
end;

procedure TIpsumButton.FontChanged(Sender: TObject);
begin
  Self.setFont(Self.Font);

  Resize;
end;

function TIpsumButton.GetCaption: String;
begin
  Result := FCaption;
end;

procedure TIpsumButton.Paint;
begin
  inherited;
  DrawIcon();
end;

procedure TIpsumButton.Resize;
begin
  inherited Resize;

  FLabelBotao.Top := 0;

  if FIconSize > 0 then
  begin
    FLabelBotao.Left    := FIconSize + 20;
    FLabelBotao.Width   := Self.Width - FIconSize - 3;
  end
  else
  begin
    FLabelBotao.Left    := 0;
    FLabelBotao.Width   := Self.Width;
  end;

  FLabelBotao.Height    := Self.Height;
end;

procedure TIpsumButton.SetAlignment(Value: TAlignment);
begin
  FAlignment            := Value;
  FLabelBotao.Alignment := FAlignment;
end;

procedure TIpsumButton.SetCaption(Value: String);
begin
  FCaption            := Value;
  FLabelBotao.Caption := FCaption;
end;

procedure TIpsumButton.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  FLabelBotao.Font.Assign(FFont);
end;

procedure TIpsumButton.SetHotColor(Value: TColor);
begin
  FHotColor := Value;
end;

procedure TIpsumButton.SetIconSize(const Value: Integer);
begin
  FIconSize   := Value;
  Resize;
end;

procedure TIpsumButton.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
end;

procedure TIpsumButton.SetImageList(const Value: TImageList);
begin
  FImageList := Value;
end;

procedure TIpsumButton.DrawIcon();
begin
  if (FImageIndex <> -1) and (Assigned(FImageList)) and (FImageList.Count-1 >= FImageIndex) then
  begin
    if Trim(FCaption) = '' then
      FImageList.Draw(Self.Canvas, (Self.Width div 2) - (FIconSize div 2), (Self.Height div 2) - (FIconSize div 2), FImageIndex)
    else
      FImageList.Draw(Self.Canvas, 8, (Self.Height div 2) - (FIconSize div 2), FImageIndex);
  end;
end;

procedure TIpsumButton.SetDown(Value: Boolean);
begin
  if not TabStop then
    Exit;

  FDown := Value;

  if FDown then
    Color := FHotColor
  else
    Color := FColor;

  Brush.Color := Color;

  Invalidate;
end;

end.
