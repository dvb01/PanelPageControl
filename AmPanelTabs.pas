unit AmPanelTabs;

interface
   //https://www.google.com/s2/favicons?domain=https://www.youtube.com/
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,Types,
  math,AmPanelTabsCustom,ES.BaseControls, ES.Images;

  {разные типы вкладок от родителя с модуля AmPanelTabsCustom}


   //////////////////////////////////////////////////////////////////
  {плюс иконка и кнопка закрытия вкладки  IB icon and button}
  type
   TAmPageControlIB =class ; // pagecontol
   TAmTabButtonClosePaint =class; // кнопка закрытия вкдадки
   TAmTabImg =class;              // иконка можно заменить родитель на TImage если у вас нет  модулей ES.BaseControls, ES.Images
   TAmPageIB= class;              // одна клиентская вкладка
   TAmTabIB=class ;           // одна  вкладка  для переключения вкладок


   TAmTabIB =class (TAmTabCustom)
     strict private
       FButtonClose:TAmTabButtonClosePaint;
       FImg: TAmTabImg;

       function GetPage:TAmPageIB;
     protected
       procedure AlignControls(AControl: TControl; var Rect: TRect);override;
       procedure SetName(const AName: TComponentName); override;
       procedure SetParent(W:TWinControl);override;
       procedure Resize;override;

       procedure NeedVisibleButClose;virtual;
     public
      constructor Create(AOwner:TComponent);override;
      destructor Destroy; override;
      property Page: TAmPageIB read GetPage;
     published
      property ButtonClose: TAmTabButtonClosePaint read FButtonClose;
      property Img: TAmTabImg read FImg;
   end;

   TAmPageIB =class  (TAmPageCustom)

    private
     function GetTab:TAmTabIB;
     function GetPageControl:TAmPageControlIB;
     procedure SetPageControl(F:TAmPageControlIB);
    protected
     procedure DrawTab;override;
     procedure PageControlInsert(F: TAmPageControlCustom);override;
    public
      function  GetClassTab: TAmTabClass;override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
       property Tab: TAmTabIB read GetTab;
       property PageControl: TAmPageControlIB read GetPageControl write SetPageControl;

   end;

   TAmPageControlIB = class (TAmPageControlCustom)
    private
     FButCloseColorActive: TColor;
     FButCloseColorDeActive: TColor;
     FButCloseSize:integer;
     FButCloseLineWidth:integer;
     FButCloseLineColor:TColor;
     FButCloseVisible:boolean;
     FImgVisible:boolean;
     FImgSize:integer;
     function GetActivPage:TAmPageIB;
     procedure SetActivePage(APage:TAmPageIB);
     function GetPagesIndex(const index:integer):TAmPageIB;

    protected
      procedure SetButCloseColorActive(C:TColor);virtual;
      procedure SetButCloseColorDeActive(C:TColor);virtual;
      procedure SetButCloseSize(Siz:integer);virtual;
      procedure SetButCloseLineWidth(Siz:integer);virtual;
      procedure SetButCloseLineColor(C:TColor);virtual;
      procedure SetButCloseVisible(V:boolean);virtual;
      procedure SetImgVisible(V:boolean);virtual;
      procedure SetImgSize(Siz:integer);virtual;
      procedure ChangeActivePage(APage: TAmPageCustom); override;


    public
      function AddPage(AClass: TAmPageClass = nil): TAmPageIB;
      property Pages[const Index: integer]: TAmPageIB read GetPagesIndex;
      function GetClassPage :TAmPageClass; override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
     property ActivePage: TAmPageIB read GetActivPage   write SetActivePage;
      property ButCloseColorActive:TColor read FButCloseColorActive write SetButCloseColorActive;
      property ButCloseColorDeActive:TColor read FButCloseColorDeActive write SetButCloseColorDeActive;
      property ButCloseSize:integer read FButCloseSize write  SetButCloseSize;
      property ButCloseLineWidth:integer read FButCloseLineWidth write  SetButCloseLineWidth;
      property ButCloseLineColor:TColor read FButCloseLineColor write  SetButCloseLineColor;
      property ButCloseVisible:boolean read FButCloseVisible write  SetButCloseVisible;
      property ImgVisible:boolean read FImgVisible write  SetImgVisible;
      property ImgSize:integer read FImgSize write  SetImgSize;

   end;



   TAmTabButtonClosePaint =class (TPanel)
     private
      FTab: TAmTabIB;
      FColorActive:TColor;
      FColorDeActive:TColor;
      FMouseEn:boolean;
      FButSize:integer;
      FLineWidth:integer;
      FLineColor:TColor;
      FVisible:boolean;
      procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
      procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
      procedure SetVisible(V:Boolean);
      procedure SetVisibleInherited(V:Boolean);
      function GetVisible:boolean;

     protected
      procedure SetButSize(Siz:integer);virtual;
      procedure SetLineWidth(Siz:integer);virtual;
      procedure SetLineColor(Col:TColor);virtual;
      procedure SetColorActive(Col:TColor);virtual;
      procedure SetColorDeActive(Col:TColor);virtual;
      procedure Paint;override;
      procedure Click;override;
      procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
      procedure MouseLeave;virtual;
      procedure MouseEnter;virtual;
     public
      constructor Create(AOwner:TComponent);override;
      destructor Destroy; override;
      property Tab: TAmTabIB read FTab;

      property VisibleInherited: boolean read GetVisible write SetVisibleInherited;

     published
      property ColorActive:TColor read FColorActive write SetColorActive;
      property ButSize:integer read FButSize write  SetButSize;
      property ColorDeActive:TColor read FColorDeActive write SetColorDeActive;
      property LineWidth:integer read FLineWidth write  SetLineWidth;
      property LineColor:TColor read FLineColor write  SetLineColor;
      property Visible:boolean read  FVisible write SetVisible;
   end;
   TAmTabImg =class (TEsImage,IChangeNotifier)
     private
      FTab: TAmTabIB;
      FImgSize:integer;
      FIsSquare:boolean;

      procedure SetVisible(V:Boolean);
      function GetVisible:boolean;
      procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
      procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
     protected
       FMouseEn:boolean;
       procedure SetImgSize(Siz:integer);virtual;
       procedure SetIsSquare(V:boolean);virtual;
       procedure Click;override;
       procedure Changed;virtual;
      procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
      procedure MouseLeave;virtual;
      procedure MouseEnter;virtual;
     public
      constructor Create(AOwner:TComponent);override;
      destructor Destroy; override;
      property Tab: TAmTabIB read FTab;
     published
      property ImgSize:integer read FImgSize write SetImgSize;
      property IsSquare:boolean read  FIsSquare write SetIsSquare;
      property Visible:boolean read  GetVisible write SetVisible;
   end;
  ////////////////////////////////////////////////////////////////////
implementation
type
TLocComponent = class (TComponent);

constructor TAmTabImg.Create(AOwner:TComponent);
begin
   inherited Create(AOwner);
   Stretch:=TImageStretch.Fit;
   FMouseEn:=false;
   FIsSquare:=true;
   FImgSize:=14;
   Visible:=true;
   Picture.PictureAdapter:=IChangeNotifier(self);
   SetBounds(5,1,FImgSize,FImgSize);



  // Picture.LoadFromFile('D:\Загрузки\bell-icon_34488.ico');
end;
destructor TAmTabImg.Destroy;
begin
   FTab:=nil;
   inherited ;
end;
procedure TAmTabImg.SetImgSize(Siz:integer);
begin
   FImgSize:=siz;
   if Assigned(Tab) then
   Tab.Realign;
end;
procedure TAmTabImg.Changed;
begin
   if Assigned(Tab) then
   Tab.Realign;
   
end;
procedure TAmTabImg.CMMouseEnter(var Message: TMessage);
begin
   inherited;
   MouseEnter;
end;
procedure TAmTabImg.CMMouseLeave(var Message: TMessage);
begin
    inherited;
    MouseLeave;
end;
procedure TAmTabImg.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseDown(self,Button,Shift, X, Y);
end;
procedure TAmTabImg.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseUp(self,Button,Shift, X, Y);
end;
procedure TAmTabImg.MouseMove(Shift: TShiftState; X,Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseMove(self,Shift, X, Y);
end;
procedure TAmTabImg.MouseLeave;
begin
   FMouseEn:=false;
   self.Invalidate;
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseLeave(self);
end;
procedure TAmTabImg.MouseEnter;
begin
    FMouseEn:=true;
    self.Invalidate;
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseEnter(self);
end;
procedure TAmTabImg.Click;
begin
   if Assigned(self.OnClick)  then inherited
   else if Assigned(Tab)  then
      Tab.TabClick
   else  inherited;
end;
procedure TAmTabImg.SetIsSquare(V:boolean);
begin
   FIsSquare:=V;
   if Assigned(Tab) then
   Tab.Realign;
end;
procedure TAmTabImg.SetVisible(V:Boolean);
begin
    inherited Visible:= V;
   if Assigned(Tab) then
   Tab.Realign;
end;
function TAmTabImg.GetVisible:boolean;
begin
   Result:= inherited Visible;
end;


                     {TAmTabButtonClosePaint}
constructor TAmTabButtonClosePaint.Create(AOwner:TComponent);
begin
   inherited Create(AOwner);
      FTab:=nil;
      FColorActive:=clGray;
      FColorDeActive:=clSilver;
      FLineColor:=clblack;
      FMouseEn:=false;
      SetButSize(14);
      FLineWidth:=1;

      Visible:=true;
      FVisible:= Visible;
end;
destructor TAmTabButtonClosePaint.Destroy;
begin
    FTab:=nil;
    FMouseEn:=false;
    inherited;
end;
procedure TAmTabButtonClosePaint.CMMouseEnter(var Message: TMessage);
begin
   inherited;
   MouseEnter;
end;
procedure TAmTabButtonClosePaint.CMMouseLeave(var Message: TMessage);
begin
    inherited;
    MouseLeave;
end;
procedure TAmTabButtonClosePaint.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseDown(self,Button,Shift, X, Y);
end;
procedure TAmTabButtonClosePaint.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseUp(self,Button,Shift, X, Y);
end;
procedure TAmTabButtonClosePaint.MouseMove(Shift: TShiftState; X,Y: Integer);
begin
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseMove(self,Shift, X, Y);
end;
procedure TAmTabButtonClosePaint.MouseLeave;
begin
   FMouseEn:=false;
   self.Invalidate;
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseLeave(self);
end;
procedure TAmTabButtonClosePaint.MouseEnter;
begin
    FMouseEn:=true;
    self.Invalidate;
    if Assigned(Tab) and Assigned(Tab.Page)  then
    Tab.Page.TabMouseEnter(self);
end;
procedure TAmTabButtonClosePaint.Click;
begin
   inherited;
   if Assigned(FTab) and Assigned(FTab.Page) then
   FTab.Page.Free;
   
end;
procedure TAmTabButtonClosePaint.SetButSize(Siz:integer);
begin
   if Siz mod 2 = 0 then  Siz:= Siz-1;

   self.Height:= Siz;
   self.Width:= Siz;
   FButSize:=Siz;
   self.Invalidate;
    if Assigned(FTab) then  FTab.Realign;
end;
procedure TAmTabButtonClosePaint.SetLineWidth(Siz:integer);
begin
  FLineWidth:=siz;
  self.Invalidate;
end;
procedure TAmTabButtonClosePaint.SetLineColor(Col:TColor);
begin
  FLineColor:=Col;
  self.Invalidate;
end;
procedure TAmTabButtonClosePaint.SetColorActive(Col:TColor);
begin
  FColorActive:=Col;
  self.Invalidate;
end;
procedure TAmTabButtonClosePaint.SetColorDeActive(Col:TColor);
begin
  FColorDeActive:=Col;
  self.Invalidate;
end;
procedure TAmTabButtonClosePaint.SetVisible(V:Boolean);
begin
    FVisible:=  V;
    SetVisibleInherited(V);
end;
procedure TAmTabButtonClosePaint.SetVisibleInherited(V:Boolean);
begin
    inherited Visible:= V;
   if Assigned(Tab) then
   Tab.Realign;
end;
function TAmTabButtonClosePaint.GetVisible:boolean;
begin
  Result:= inherited Visible;
end;
procedure TAmTabButtonClosePaint.Paint;
var C:TCanvas;
siz:integer;
P:TPoint;
begin
  C:= Canvas;
  if FMouseEn then     C.Brush.Color:=  ColorActive
  else                 C.Brush.Color:=  ColorDeActive;

  C.Pen.Color:=FLineColor;
  C.Pen.Width:=FLineWidth;
  c.FillRect(ClientRect);
  siz:=(FButSize-(FButSize div 3))div 2;
  if siz<=0 then exit;
  


  P:=Point(Width div 2  ,Height div 2 );
  C.MoveTo(P.X,P.Y);
  C.LineTo(P.X-siz,P.Y+siz);

  C.MoveTo(P.X,P.Y);
  C.LineTo(P.X+siz,P.Y+siz);

  C.MoveTo(P.X,P.Y);
  C.LineTo(P.X-siz,P.Y-siz);

  C.MoveTo(P.X,P.Y);
  C.LineTo(P.X+siz,P.Y-siz);
end;


                   {TAmTabIB}
constructor TAmTabIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FButtonClose:=TAmTabButtonClosePaint.Create(self);
    FButtonClose.FTab:=self;

    FImg:= TAmTabImg.Create(self);
    FImg.FTab:=self;
   // FImg.Picture.OnChange:=
    include(TLocComponent(FButtonClose).FComponentStyle, csSubComponent);
    include(TLocComponent(FImg).FComponentStyle, csSubComponent);
    //;

//    FButtonClose.Visible:=false;
  //  FImg.Visible:=false;

end;
destructor TAmTabIB.Destroy;
begin
    inherited;
end;
function TAmTabIB.GetPage:TAmPageIB;
begin
    Result:= nil;
    if Assigned( inherited Page) then
    Result:= TAmPageIB(inherited Page);
end;
procedure TAmTabIB.AlignControls(AControl: TControl; var Rect: TRect);
var wh,tp:integer;
begin
  //showmessage('AlignControls');
   if (FImg.Parent<>nil) and (FImg.Visible)and (Assigned(FImg.Picture.Graphic))  then
   begin
      //if FImg.IsSquare then

         wh:= min(FImg.ImgSize,self.Height-2);
         tp:= max(1,(self.Height div 2)  -  (wh div 2));
         FImg.SetBounds(5,tp,wh,wh);
         Rect.Left:= FImg.Left +FImg.Width;
   end;
   if (FImg.Parent<>nil) and FButtonClose.VisibleInherited then
   begin
     FButtonClose.Left:=self.Width - FButtonClose.Width -5;
     tp:= max(0,(self.Height div 2)  -  ((FButtonClose.Height) div 2));
     FButtonClose.Top:= tp;
     Rect.Right:=  FButtonClose.Left;
   end;
   Rect.Right:=  Rect.Right -15;
   inherited AlignControls(AControl,Rect);
end;
procedure TAmTabIB.SetName(const AName: TComponentName);
begin
   inherited;
   FButtonClose.Name:='ButtonClose';
   FButtonClose.Caption:='';
   FImg.Name:= 'Img';
end;
procedure TAmTabIB.SetParent(W:TWinControl);
begin
    inherited;
    if W=nil then  exit;
   FButtonClose.Parent:=self;
   FImg.Parent:=self;
end;
procedure TAmTabIB.Resize;
begin
    inherited;
    NeedVisibleButClose;
end;

procedure TAmTabIB.NeedVisibleButClose;
begin
    if (FButtonClose.Parent<>nil)and FButtonClose.Visible then
    begin
       if assigned(Page) and Assigned(Page.PageControl) then
       begin
         if Page.PageControl.ActivePage <>  Page then
         begin
            if self.Width < FButtonClose.Width*6 then
            begin
               if FButtonClose.VisibleInherited then
               FButtonClose.VisibleInherited:=false;
            end
            else
            begin
               if not  FButtonClose.VisibleInherited then
               FButtonClose.VisibleInherited:=true;
            end;
         end
         else
         begin
               if not  FButtonClose.VisibleInherited then
               FButtonClose.VisibleInherited:=true;
         end;

       end;

    end;
end;

                   {TAmPageIB}
constructor TAmPageIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TAmPageIB.Destroy;
begin
    inherited;
end;
function  TAmPageIB.GetClassTab: TAmTabClass;
begin
     Result:= TAmTabIB;
end;
procedure TAmPageIB.DrawTab;
begin
   inherited;
   Tab.NeedVisibleButClose;
end;
procedure TAmPageIB.PageControlInsert(F: TAmPageControlCustom);
var p: TAmPageControlIB;
begin
   inherited PageControlInsert(F);
   if F = nil then exit;
   if not (F is TAmPageControlIB) then exit;

   if IsOptionDefault then
   begin
     p:= TAmPageControlIB(F);
     self.Tab.ButtonClose.FColorActive:=p.ButCloseColorActive;
     self.Tab.ButtonClose.FColorDeActive:=p.ButCloseColorDeActive;
     self.Tab.ButtonClose.FButSize:=p.ButCloseSize;
     self.Tab.ButtonClose.FLineWidth:=p.ButCloseLineWidth;
     self.Tab.ButtonClose.FLineColor:=p.ButCloseLineColor;
     self.Tab.ButtonClose.Visible:= p.ButCloseVisible;

     self.Tab.Img.FImgSize:=  p.ImgSize;
     self.Tab.Img.Visible:=  p.ImgVisible;
   end;
end;
function TAmPageIB.GetPageControl:TAmPageControlIB;
begin
    Result:= nil;
    if Assigned( inherited PageControl) then
    Result:= TAmPageControlIB(inherited PageControl);
end;
procedure TAmPageIB.SetPageControl(F:TAmPageControlIB);
begin
    inherited  PageControl:=F;
end;
function TAmPageIB.GetTab:TAmTabIB;
begin
   Result:=nil;
  if Assigned(inherited Tab) then
  Result:= TAmTabIB(inherited Tab);
end;




                   {TAmPageControlIB}
constructor TAmPageControlIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
     FButCloseColorActive:=$00EBEBEB;
     FButCloseColorDeActive:=clSilver;
     FButCloseSize:=14;
     FButCloseLineWidth:=1;
     FButCloseLineColor:=clblack;


     FButCloseVisible:=true;
     FImgVisible:=true;
     FImgSize:=14;
end;
destructor TAmPageControlIB.Destroy;
begin
    inherited;
end;
function TAmPageControlIB.GetClassPage :TAmPageClass;
begin
    Result:= TAmPageIB;
end;
function TAmPageControlIB.AddPage(AClass: TAmPageClass = nil): TAmPageIB;
begin
  if AClass = nil then
    AClass := TAmPageIB;
    Result:= TAmPageIB(inherited AddPage(AClass));
end;
function TAmPageControlIB.GetActivPage:TAmPageIB;
begin
    Result:=nil;
    if Assigned(inherited ActivePage) then
    Result:= TAmPageIB(inherited ActivePage);
end;
procedure TAmPageControlIB.SetActivePage(APage:TAmPageIB);
begin
    inherited  ActivePage:=APage;
end;
function TAmPageControlIB.GetPagesIndex(const index:integer):TAmPageIB;
var O:TObject;
begin
    Result:=nil;
    O:= inherited Pages[index];
    if Assigned(O) then Result:= TAmPageIB(O);
end;
procedure TAmPageControlIB.SetButCloseColorActive(C:TColor);
var I: Integer;
begin
     FButCloseColorActive:=C;
     for I := 0 to PageCount-1 do
     Pages[i].Tab.ButtonClose.ColorActive:= FButCloseColorActive;
end;
procedure TAmPageControlIB.SetButCloseColorDeActive(C:TColor);
var I: Integer;
begin
     FButCloseColorDeActive:=C;
     for I := 0 to PageCount-1 do
     Pages[i].Tab.ButtonClose.ColorDeActive:= FButCloseColorDeActive;
end;
procedure TAmPageControlIB.SetButCloseSize(Siz:integer);
var I: Integer;
begin
     FButCloseSize:=Siz;
     for I := 0 to PageCount-1 do
     Pages[i].Tab.ButtonClose.ButSize:= FButCloseSize;
end;
procedure TAmPageControlIB.SetButCloseLineWidth(Siz:integer);
var I: Integer;
begin
     FButCloseLineWidth:=Siz;
     for I := 0 to PageCount-1 do
     Pages[i].Tab.ButtonClose.LineWidth:= FButCloseLineWidth;
end;
procedure TAmPageControlIB.SetButCloseLineColor(C:TColor);
var I: Integer;
begin
     FButCloseLineColor:=C;
     for I := 0 to PageCount-1 do
     Pages[i].Tab.ButtonClose.LineColor:= FButCloseLineColor;
end;
procedure TAmPageControlIB.SetButCloseVisible(V:boolean);
var I: Integer;
begin
    FButCloseVisible:= V;
     for I := 0 to PageCount-1 do
     begin
     Pages[i].Tab.ButtonClose.Visible:= FButCloseVisible;
     Pages[i].Tab.Realign;
     end;

end;
procedure TAmPageControlIB.SetImgVisible(V:boolean);
var I: Integer;
begin
    FImgVisible:= V;
     for I := 0 to PageCount-1 do
     begin
     Pages[i].Tab.Img.Visible:= FImgVisible;
     Pages[i].Tab.Realign;
     end;
end;
procedure TAmPageControlIB.SetImgSize(Siz:integer);
var I: Integer;
begin
    FImgSize:=siz;
     for I := 0 to PageCount-1 do
     begin
     Pages[i].Tab.Img.ImgSize:= FImgSize;
     end;
end;
procedure TAmPageControlIB.ChangeActivePage(APage: TAmPageCustom);
var Old,New:TAmPageIB;
c1,c2:TColor;
 procedure Loc_ReplaceColorBut(B:TAmPageIB);
 begin
   if not Assigned(B) then exit;
   c1:=B.Tab.ButtonClose.ColorActive;
   c2:=B.Tab.ButtonClose.ColorDeActive;
   B.Tab.ButtonClose.ColorActive:=c2;
   B.Tab.ButtonClose.ColorDeActive:=c1;
 end;
begin
   Old := self.ActivePage;
   inherited;
   New:= self.ActivePage;
   Loc_ReplaceColorBut(Old);
   Loc_ReplaceColorBut(New);
end;




  {   ШАБЛОН НАСЛЕДОВАНИЯ
  type
   TAmPageControlIB =class ;

   TAmTabIB =class  (TAmPanelTabCustom)
     type
       TTabIB =class (TTab)
         strict private
           function GetPage:TAmTabIB;
         protected
         public
          constructor Create(AOwner:TComponent);override;
          destructor Destroy; override;
         published
          property Page: TAmTabIB read GetPage;
       end;
    private
     function GetPageControl:TAmPageControlIB;
     procedure SetPageControl(F:TAmPageControlIB);
    protected
     function  GetClassTTab: TAmPanelTabCustom.TTabClass;override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
     property PageControl: TAmPageControlIB read GetPageControl write SetPageControl;
   end;

   TAmPageControlIB = class (TAmPanelPageControlCustom)
    private
     function GetActivPage:TAmTabIB;
     procedure SetActivePage(ATab:TAmTabIB);
    public
      function AddTab(AClass: TAmPanelTabClass = nil): TAmTabIB;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
     property ActivePage: TAmTabIB read GetActivPage   write SetActivePage;
   end;

  ////////////////////////////////////////////////////////////////////




implementation

constructor TAmTabIB.TTabIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TAmTabIB.TTabIB.Destroy;
begin
    inherited;
end;
function TAmTabIB.TTabIB.GetPage:TAmTabIB;
begin
    Result:= nil;
    if Assigned( inherited Page) then
    Result:= TAmTabIB(inherited Page);
end;


constructor TAmTabIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TAmTabIB.Destroy;
begin
    inherited;
end;
function  TAmTabIB.GetClassTTab: TAmPanelTabCustom.TTabClass;
begin
     Result:= TTabIB;
end;
function TAmTabIB.GetPageControl:TAmPageControlIB;
begin
    Result:= nil;
    if Assigned( inherited PageControl) then
    Result:= TAmPageControlIB(inherited PageControl);
end;
procedure TAmTabIB.SetPageControl(F:TAmPageControlIB);
begin
    inherited  PageControl:=F;
end;





constructor TAmPageControlIB.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TAmPageControlIB.Destroy;
begin
    inherited;
end;
function TAmPageControlIB.AddTab(AClass: TAmPanelTabClass = nil): TAmTabIB;
begin
    Result:= inherited AddTab(TAmTabIB);
end;
function TAmPageControlIB.GetActivPage:TAmTabIB;
begin
    Result:=nil;
    if Assigned(inherited ActivePage) then
    Result:= TAmTabIB(inherited ActivePage);
end;
procedure TAmPageControlIB.SetActivePage(ATab:TAmTabIB);
begin
    inherited  ActivePage:=ATab;
end;
   }
end.
