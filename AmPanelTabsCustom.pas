unit AmPanelTabsCustom;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,Types,
  math,Vcl.StdCtrls;




  {   ЎјЅЋќЌ Ќј—Ћ≈ƒќ¬јЌ»я
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

type

  TLocPanel = class(TPanel)
  public
    constructor Create(AOwner: TComponent); override;
  end;
  TAmPanelTabListTab = class(TLocPanel)
    protected
     procedure AlignControls(AControl: TControl; var Rect: TRect);override;
  end;


  // родитель pagecontrol
  TAmPageControlCustom = class;

  // клиентска€ панель вкладка
  TAmPageCustom =class;

  // топ панель вкладка €вд€етс€ частью   TAmTabCustom
  TAmTabCustom =class;

  TAmPageClass = class of TAmPageCustom;
  TAmTabClass = class of  TAmTabCustom;

  {
    одна вкладка это 2 панели
    1. клиентска€ TAmTabCustom
    2. сама вкладка  TAmTabTopCustom котора€ с верху дл€ переключени€

     TAmTabCustom создает  TAmTabTopCustom
     а при установке pagecontrol  парент  TAmTabTopCustom устанавливаетс€  pagecontrol

     так же модул€х есть классы с иконками и кнопками закрыти€ вкладок
     их можно использовать еще как пример наследовани€


    ---------:      TAmTabCustom   :--------
    :--------                      ---------:
    :                                       :
    :              TAmPageCustom            :
    :---------------------------------------:

  }




    TAmTabCustom = class(TLocPanel)
    private

      FPage: TAmPageCustom;
      FSplit:TPen;
      FLabelCaption:TLabel;
      FCaptionText:string;
      FColorActive,FColorDeActive:TColor;

      procedure SetColorActive(V:TColor);
      procedure SetColorDeActive(V:TColor);
      function GetCaption:string;
      procedure SetCaption(V:string);
      procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
      procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    protected
      procedure SetName(const AName: TComponentName); override;
      procedure Click;override;
      procedure Paint;override;
      procedure PaintSplit;virtual;
      procedure SetPage(APage: TAmPageCustom);
      procedure SetParent(W:TWinControl);override;
      procedure Resize; override;
      procedure AlignControls(AControl: TControl; var Rect: TRect);override;

      procedure PageCaptionClick(S:TObject);
      procedure TabClick;virtual;

      procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
      procedure MouseLeave;virtual;
      procedure MouseEnter;virtual;
    public
      constructor Create(AOwner:TComponent);override;
      destructor Destroy; override;
    published
      property LabelCaption :TLabel read FLabelCaption;
      property Caption :string read GetCaption write SetCaption;

      property Page: TAmPageCustom read FPage;
      property Split: TPen read FSplit;
      property ColorActive:TColor read FColorActive write  SetColorActive;
      property ColorDeActive:TColor read FColorDeActive write  SetColorDeActive;
    end;


  TAmPageCustom = class(TLocPanel)
  private
    FTab: TAmTabCustom;
    FPageIndex: integer;
    FPageControl: TAmPageControlCustom;

    FTabIndexDesign:integer;
    FIsOptionDefault:boolean;

    procedure SetPageControl(F: TAmPageControlCustom);
  protected
    procedure SetName(const AName: TComponentName); override;
    procedure DrawTab; virtual;
    procedure Paint;override;
    procedure ReadState(Reader: TReader); override;
    procedure SetTabIndexDesign(index:integer);

    procedure PageControlInsert(F: TAmPageControlCustom);  virtual;
    procedure PageControlRemove(F: TAmPageControlCustom);  virtual;

    procedure TabMouseDown(Initiator:TControl;Button: TMouseButton;Shift: TShiftState; X, Y: Integer);virtual;
    procedure TabMouseUp(Initiator:TControl;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);virtual;
    procedure TabMouseMove(Initiator:TControl;Shift: TShiftState; X,Y: Integer); virtual;
    procedure TabMouseLeave(Initiator:TControl); virtual;
    procedure TabMouseEnter(Initiator:TControl); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property PageIndex: integer read FPageIndex;
    function  GetClassTab: TAmTabClass;virtual;
    // property TabVisible:boolean read FTabVisible;
  published
    property PageControl: TAmPageControlCustom read FPageControl write SetPageControl;

    property Tab: TAmTabCustom read FTab;
    property IsOptionDefault: boolean read FIsOptionDefault write FIsOptionDefault;

    // пор€док отображени€ вкладок (можно не соблюдать последовательность чем число больше тем дальше вкладка)
    // aling вкладок выполн€етс€ в TAmPanelPageControlListTab.AlignControls
    property TabIndexDesign:Integer read FTabIndexDesign write  SetTabIndexDesign;
  end;

  {родитедьска€ панель список вкладок}
  TAmPageControlCustom = class(TLocPanel)
  private
    FInSetActivePage: boolean;
    FPages: TList;
    FTabsPanel: TAmPanelTabListTab;
//    FPanelClient: TLocPanel;
    FActivePage: TAmPageCustom;
    FTabsIsTop:boolean;
    FTabsW:integer;
    FTabsH:integer;
    FTabsActiveColor:TColor;
    FTabsDeActiveColor:TColor;
    FTabsSplit:TPen;
    FTabsAutoSize:boolean;
    FTabsAutoSizeMax:integer;
    FTabsAutoSizeMin:integer;
    FTabsFont: TFont;
    function GetPageCount: integer;
    function GetPagesIndex(const index: integer): TAmPageCustom;
    function GetActivPage: TAmPageCustom;
    procedure SetActivePage(F: TAmPageCustom);

    function GetActivPageIndex: integer;
    procedure SetActivPageIndex(V: integer);

    procedure SetTabsW(V:integer);
    procedure SetTabsH(V:integer);
    procedure SetTabsActiveColor(V:TColor);
    procedure SetTabsDeActiveColor(V:TColor);

    function GetColor : TColor;
    procedure SetColor(V:TColor);
    procedure InsertNewPage(APage: TAmPageCustom);

    procedure SetTabsFont(F:TFont);
    procedure TabsFontChangeEvent(S:TObject);
    procedure TabsAutoSizeSet(const Value: boolean);
  protected
    procedure SetParent(W: TWinControl); override;
    procedure SetName(const AName: TComponentName); override;
    procedure TabsUpdate; virtual;
    procedure ChangeActivePage(APage: TAmPageCustom); virtual;
    procedure TabsDraw; virtual;
    procedure TabsClickChange(APage:TAmPageCustom); virtual;
    procedure TabsFontChange();virtual;

    function FindNextPage(CurPage: TAmPageCustom;
      GoForward, CheckTabVisible: boolean): TAmPageCustom;
    procedure SetTabsIsTop(Value:Boolean);
    procedure UpdatePositionPages;
    procedure TabsSplitChange(S:TObject);
    procedure Resize;override;
    procedure ResizeTabs(delta:integer=0);virtual;
    procedure ResizeTabsPost;

    procedure TabMouseDown(APage:TAmPageCustom;Initiator:TControl; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);virtual;
    procedure TabMouseUp(APage:TAmPageCustom;Initiator:TControl; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);virtual;
    procedure TabMouseMove(APage:TAmPageCustom;Initiator:TControl;  Shift: TShiftState; X,Y: Integer); virtual;
    procedure TabMouseLeave(APage:TAmPageCustom;Initiator:TControl); virtual;
    procedure TabMouseEnter(APage:TAmPageCustom;Initiator:TControl); virtual;
  public
    //нова€
    function AddPage(AClass: TAmPageClass = nil): TAmPageCustom;

    //удалить
    procedure DeletePage(Page: TAmPageCustom);
    procedure DeleteIndex(PageIndex: integer);

    property PageCount: integer read GetPageCount;
    property Pages[const Index: integer]: TAmPageCustom read GetPagesIndex;
    property ActivePageIndex: integer read GetActivPageIndex   write SetActivPageIndex;

    // удалить все
    procedure Clear; virtual;

    // запускает DrawTab в каждой отдельной вкдадке
    procedure TabsReDraw;

    // при TabAutoSize =true пересчитывает размер вкладки
    procedure TabsResize;

    // получает число дл€ проперти вкладки TAmPanelTabCustom.TabIndexDesign что бы вкладка оказадась в конце (пор€док отображени€ вкладок)
    function GetNextTabIndexDesign :integer;

    function GetClassPage :TAmPageClass; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   published

    // текуща€€ активна€ вкладка
    property ActivePage: TAmPageCustom read GetActivPage   write SetActivePage;

    // верхн€€ панель дл€ переключени€ вкладок
    property TabsPanel: TAmPanelTabListTab read FTabsPanel;

    // положение вкладок с боку или вверху
    property TabsIsTop: boolean read FTabsIsTop   write SetTabsIsTop;



    // ширина вкладок посто€нна€
    property TabsW: integer read FTabsW write SetTabsW;
    //высота вкладок посто€нна€
    property TabsH: integer read FTabsH write SetTabsH;

    // цвета
    property TabsActiveColor: TColor read FTabsActiveColor write SetTabsActiveColor;
    property TabsDeActiveColor: TColor read FTabsDeActiveColor write SetTabsDeActiveColor;
    property Color: TColor read GetColor write SetColor;

    // натройки текта вкладок
    property TabsFont: TFont read FTabsFont write SetTabsFont;

   // разделитель вкладок можно отлючить если ширину в 0
    property TabsSplit: TPen read FTabsSplit write FTabsSplit;

    // измен€ть размер вкладок на автомате
    property TabsAutoSize: boolean read FTabsAutoSize write TabsAutoSizeSet;

    //пределы размеров вкладки при TabAutoSize =true
    property TabsAutoSizeMax: integer read FTabsAutoSizeMax write FTabsAutoSizeMax;
    property TabsAutoSizeMin: integer read FTabsAutoSizeMin write FTabsAutoSizeMin;

  end;






implementation
type
TLocComponent = class (TComponent);

procedure TAmPanelTabListTab.AlignControls(AControl: TControl;
                                                  var Rect: TRect);
var  P:TAmPageControlCustom;
     i:integer;
     APage:TAmPageCustom;
     lt:integer;
begin
    if not Assigned(Parent)
    or not (self.Parent is TAmPageControlCustom )   then
    begin
      inherited ;
    end
    else
    begin
       P:= TAmPageControlCustom(Parent);

       lt:=0;
       for I := 0  to P.PageCount-1 do
       begin
          APage:= P.Pages[i];
          if APage.Tab.Align<>alNone then
          APage.Tab.Align:= alNone;
          if P.TabsIsTop then
          begin
             APage.Tab.SetBounds(lt,0,APage.Tab.Width,self.Height);
             lt:= lt+APage.Tab.Width;
          end
          else
          begin
             APage.Tab.SetBounds(0,lt,Width,APage.Tab.Height);
             lt:= lt+APage.Tab.Height;
          end;

       end;


    end;
end;
{ TAmPageControlCustom }
constructor TAmPageControlCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csDoubleClicks, csPannable, csGestures,csOpaque];
  FTabsFont:= TFont.Create;
  FTabsFont.OnChange:= TabsFontChangeEvent;
  FTabsAutoSize:=true;
  FTabsAutoSizeMax:=300;
  FTabsAutoSizeMin:=40;
  FTabsSplit:=TPen.Create;
  FTabsSplit.OnChange:= TabsSplitChange;
  FTabsIsTop:=true;
  FTabsActiveColor:=$00F4F4F4;
  FTabsDeActiveColor:=clSilver;
  FTabsW:=20;
  FTabsH:=20;
  self.Width:=300;
  self.Height:=200;

  FPages := TList.Create;
  FTabsPanel := TAmPanelTabListTab.Create(self);
 // FPanelTab.Visible:=true;

  //FPanelClient := TLocPanel.Create(self);

  include(FTabsPanel.FComponentStyle, csSubComponent);
 // include(FPanelClient.FComponentStyle, csSubComponent);

  FActivePage := nil;
  FInSetActivePage := false;

end;

destructor TAmPageControlCustom.Destroy;
begin
//  include(ComponentState, csDestroying);
  Clear;
  FreeAndNil(FPages);
  if Assigned(FTabsSplit) then
  FreeAndNil(FTabsSplit);
  if Assigned(FTabsFont) then
  FreeAndNil(FTabsFont);

  inherited;
end;
function TAmPageControlCustom.GetClassPage :TAmPageClass;
begin
   Result:= TAmPageCustom;
end;
function TAmPageControlCustom.GetNextTabIndexDesign :integer;
var i:integer;
begin
   Result:=-1;
   for I := 0 to PageCount-1 do
   Result:= max(Result,pages[i].TabIndexDesign);
   inc(Result);
end;

procedure TAmPageControlCustom.Clear;
var
  i: integer;
  procedure Loc_Clear(L: TList);
  var
    i: integer;
  begin
    for i := L.Count - 1 downto 0 do
      if Assigned(L[i]) then
        TObject(L[i]).Free;
    L.Clear;
  end;

begin
  Loc_Clear(FPages);
  FActivePage := nil;
end;
procedure TAmPageControlCustom.Resize;
begin
     inherited;
     ResizeTabs;
end;
procedure TAmPageControlCustom.ResizeTabsPost;
begin
  if CanFocus then
  Sendmessage(self.Handle,WM_SIZE,0,0);
end;
procedure TAmPageControlCustom.TabsResize;
begin
   ResizeTabs;
end;
procedure TAmPageControlCustom.ResizeTabs(delta:integer=0);//;
var res,Wh:integer;

begin


     if not TabsAutoSize or not CanFocus then exit;

     if PageCount<=0 then exit;

     if (TabsAutoSizeMin<0) or (TabsAutoSizeMin>2000) then exit;

     if (TabsAutoSizeMax<0) or (TabsAutoSizeMax>2000) then exit;


     if TabsIsTop then Wh:= Width

     else               Wh:= Height;


     Wh:=Wh-10;

     if Wh<0 then exit;



     res:= round(  Wh / PageCount );


     if res      <     TabsAutoSizeMin then res:=TabsAutoSizeMin
     else if res  >    TabsAutoSizeMax then res:=TabsAutoSizeMax;
     res:= max(res-delta,TabsAutoSizeMin);

     if TabsIsTop then TabsW:= res
     else               TabsH:= res

end;
procedure TAmPageControlCustom.TabMouseDown(APage:TAmPageCustom;Initiator:TControl;
                                           Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin

end;
procedure TAmPageControlCustom.TabMouseUp(APage:TAmPageCustom;Initiator:TControl;
                                         Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;
procedure TAmPageControlCustom.TabMouseMove(APage:TAmPageCustom; Initiator:TControl;
                                            Shift: TShiftState; X,Y: Integer);
begin

end;
procedure TAmPageControlCustom.TabMouseLeave(APage:TAmPageCustom ;Initiator:TControl);
begin

end;
procedure TAmPageControlCustom.TabMouseEnter(APage:TAmPageCustom;Initiator:TControl);
begin

end;
procedure TAmPageControlCustom.SetParent(W: TWinControl);
begin
  inherited;
  if W=nil then exit;

  FTabsPanel.Parent := self;
  //FPanelTab.Color := clGray;
   //FTabsPanel.Color:=clSilver;
  //FPanelClient.Parent := self;
 // FPanelClient.Align := alClient;
 // FPanelClient.Color := clYellow;

  TabsUpdate;
  if ActivePageIndex>=0 then   
  SetActivePage(self.Pages[ActivePageIndex]);
end;

procedure TAmPageControlCustom.SetName(const AName: TComponentName);
begin
  inherited;
  if AName <> '' then
  begin
    FTabsPanel.Name := 'PanelTab';
    FTabsPanel.Caption:='';
    Caption:='';
    //FPanelClient.Name := 'PanelClient';
  end;
end;

function TAmPageControlCustom.GetPageCount: integer;
begin
  Result := FPages.Count;
end;

function TAmPageControlCustom.AddPage(AClass: TAmPageClass)   : TAmPageCustom;

begin
  if AClass = nil then
    AClass := GetClassPage;

  Result := AClass.Create(self);
  Result.PageControl := self;
end;

procedure TAmPageControlCustom.DeletePage(Page: TAmPageCustom);
begin
    Page.Free;
end;
procedure TAmPageControlCustom.DeleteIndex(PageIndex: integer);
begin
   Pages[PageIndex].Free;
end;

function TAmPageControlCustom.GetPagesIndex(const index: integer): TAmPageCustom;
begin
  Result := nil;
  if (index >= 0) and (index < FPages.Count) then
    Result := TAmPageCustom(FPages[index]);
end;

function TAmPageControlCustom.GetActivPage: TAmPageCustom;
begin
  Result := FActivePage;
end;

procedure TAmPageControlCustom.SetActivePage(F: TAmPageCustom);
begin
  if (F <> nil) and (F.PageControl <> self) then
    Exit;
  if FInSetActivePage then
    Exit;

  FInSetActivePage := True;
  try
    ChangeActivePage(F);
  finally
    FInSetActivePage := false;
  end;
end;

function TAmPageControlCustom.GetActivPageIndex: integer;
begin
  Result := -1;
  if Assigned(FActivePage) then
    Result := FActivePage.FPageIndex;
end;

procedure TAmPageControlCustom.SetActivPageIndex(V: integer);
begin
  if (V <> ActivePageIndex) and (V >= 0) then
    SetActivePage(self.Pages[V]);
end;

procedure TAmPageControlCustom.ChangeActivePage(APage: TAmPageCustom);
begin
  if FActivePage = APage then
    Exit;

 // ParentForm := GetParentForm(self);
 // if (ParentForm <> nil) and (FActivePage <> nil) and
 //   FActivePage.ContainsControl(ParentForm.ActiveControl) then
 // begin
 //   ParentForm.ActiveControl := FActivePage;

 // end;
  if (APage <> nil) and (self.Parent<>nil) then
  begin

    APage.Visible := True;
    APage.BringToFront;
   // if (ParentForm <> nil) and (FActivePage <> nil) and
   //   (ParentForm.ActiveControl = FActivePage) then
  //    if ATab.CanFocus then
   //     ParentForm.ActiveControl := ATab
   //   else
   //     ParentForm.ActiveControl := self;
    // if not F.TabVisible and TStyleManager.IsCustomStyleActive then
    // RedrawWindow(Page.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);
  end;
  if FActivePage <> nil then
    FActivePage.Visible := false;
  FActivePage := APage;

  TabsDraw;

end;
procedure TAmPageControlCustom.TabsDraw;
var i:integer;
begin
   for I := 0 to FPages.Count-1 do
   begin
   TAmPageCustom(FPages[i]).FPageIndex:=i;
   TAmPageCustom(FPages[i]).DrawTab;
   end;
end;
procedure TAmPageControlCustom.TabsReDraw;
begin
  TabsDraw;
  Invalidate;
end;
procedure TAmPageControlCustom.TabsAutoSizeSet(const Value: boolean);
begin
  FTabsAutoSize := Value;
  ResizeTabs;
end;

procedure TAmPageControlCustom.TabsClickChange(APage:TAmPageCustom);
begin
  ActivePage:= APage;
end;

procedure TAmPageControlCustom.TabsUpdate;
//var
//  i,l: integer;
 // Tab:TAmPanelTabCustom;
begin

  if TabsIsTop then
  begin
   if FTabsPanel.Align<> alTop then
   FTabsPanel.Align := alTop;
   if FTabsPanel.Height<> FTabsH then
   FTabsPanel.Height := FTabsH;
  end
  else
  begin
    if FTabsPanel.Align<> alleft then
    FTabsPanel.Align := alleft;
    if FTabsPanel.Width<> FTabsW then
    FTabsPanel.Width := FTabsW;
  end;

  TabsDraw;
  ResizeTabsPost;

  // запускает процедуру   TAmPanelPageControlListTab.AlignControls
  // где и установитс€ последовательность вкладок
  TabsPanel.Realign;


 // if (FPages.Count > 0) then
 // begin
     // if not Assigned(ActivePage) then
      // SetActivePage(TAmPanelTabCustom(FPages[0]));
 // end;
 // else  SetActivePage(nil);
{  for i := 0 to FPages.Count - 1 do
  begin
    Tab:= TAmPanelTabCustom(FPages[i]);
    Tab.FPageIndex:=I;
    if (FActivePage = Tab) and  not Tab.Visible then
    Tab.Visible:=true
    else if (FActivePage <> Tab) and   Tab.Visible then
    Tab.Visible:=false;
    Tab.DrawTab;
  end;}
 // l:=0;



end;

function TAmPageControlCustom.FindNextPage(CurPage: TAmPageCustom;
  GoForward, CheckTabVisible: boolean): TAmPageCustom;
var
  i, StartIndex: integer;
begin
  if FPages.Count <> 0 then
  begin
    StartIndex := FPages.IndexOf(CurPage);
    if StartIndex = -1 then
      if GoForward then
        StartIndex := FPages.Count - 1
      else
        StartIndex := 0;
    i := StartIndex;
    repeat
      if GoForward then
      begin
        Inc(i);
        if i = FPages.Count then
          i := 0;
      end
      else
      begin
        if i = 0 then
          i := FPages.Count;
        Dec(i);
      end;
      Result := TAmPageCustom(FPages[i]);
     // if not CheckTabVisible  then
        Exit;
    until i = StartIndex;
  end;
  Result := nil;
end;
procedure TAmPageControlCustom.SetTabsIsTop(Value:Boolean);
begin
    FTabsIsTop:=Value;
    UpdatePositionPages;
end;
procedure  TAmPageControlCustom.UpdatePositionPages;
begin
    if self.Parent=nil then exit;
    TabsUpdate;
end;
procedure TAmPageControlCustom.TabsSplitChange(S:TObject);
var i:integer;
begin
   for I := 0 to PageCount-1 do
   if Assigned(Pages[i].Tab.Split) then
   begin
      Pages[i].Tab.Split.Assign(FTabsSplit);
      Pages[i].Tab.Invalidate;
   end;

end;
procedure TAmPageControlCustom.SetTabsW(V:integer);
var
  I: Integer;
begin
    FTabsW:= V;
    if FTabsW<0 then FTabsW:=0;

    if TabsIsTop then
    begin
       for I := 0 to PageCount-1 do
       Pages[i].Tab.Width:= FTabsW;
    end
    else
    begin
      TabsPanel.Width:= FTabsW;
    end;

end;
procedure TAmPageControlCustom.SetTabsH(V:integer);
var
  I: Integer;
begin
    FTabsH:= V;
    if FTabsH<0 then FTabsH:=0;

    if TabsIsTop then
    begin
       TabsPanel.Height:= FTabsH;
    end
    else
    begin
       for I := 0 to PageCount-1 do
       Pages[i].Tab.Height:= FTabsH;
    end;

end;
procedure TAmPageControlCustom.SetTabsActiveColor(V:TColor);
var
  I: Integer;
begin
       FTabsActiveColor:=V;
       for I := 0 to PageCount-1 do
       Pages[i].Tab.ColorActive:= FTabsActiveColor;
end;
procedure TAmPageControlCustom.SetTabsDeActiveColor(V:TColor);
var
  I: Integer;
begin
       FTabsDeActiveColor:=V;
       for I := 0 to PageCount-1 do
       Pages[i].Tab.ColorDeActive:= FTabsDeActiveColor;

end;
function TAmPageControlCustom.GetColor : TColor;
begin
  Result:= inherited Color;
end;
procedure TAmPageControlCustom.SetColor(V:TColor);
begin
   inherited Color := V;
    FTabsPanel.Color:=V;
    //FPanelClient.Color:=V;
end;
procedure  TAmPageControlCustom.InsertNewPage(APage: TAmPageCustom);
var index:integer;
    function Loc_GetIndexInsert:integer;
    var i:integer;
    begin
      Result:= -1;
      if APage.TabIndexDesign<0 then
      begin
       Result:=PageCount;
       exit;
      end;

      for I := 0 to PageCount-1 do
      if Pages[i].TabIndexDesign>=APage.TabIndexDesign then
      begin
        Result:= I;
        break;
      end;
    end;
begin
    if Assigned(APage.FPageControl) then
    raise Exception.Create('Error InsertNewTabToPages вкладка уже находитс€ в таблице');

    index:=Loc_GetIndexInsert;
    if (index<0) or  (index>=FPages.Count) then
    FPages.Add(APage)
    else FPages.Insert(index,APage);
    APage.FPageControl := self;
end;
procedure TAmPageControlCustom.SetTabsFont(F:TFont);
begin

     if  Assigned(FTabsFont) then  FreeAndNil(FTabsFont);
     FTabsFont:= F;
     if Assigned(FTabsFont) then
     FTabsFont.OnChange:= TabsFontChangeEvent;
end;
procedure TAmPageControlCustom.TabsFontChangeEvent(S:TObject);
begin
    TabsFontChange;
end;
procedure TAmPageControlCustom.TabsFontChange();
var i:integer;
begin
    for I := 0 to PageCount-1 do
    Pages[i].Tab.LabelCaption.Font.Assign(FTabsFont);
end;

                          {TAmTabCustom}
constructor TAmTabCustom.Create(AOwner:TComponent);
begin
  inherited;
  FSplit:=TPen.Create;
  FCaptionText:='';
  FLabelCaption:=TLabel.Create(self);
  FLabelCaption.AutoSize:=true;
  FLabelCaption.OnClick:= PageCaptionClick;
  inherited Caption:='';

    include(TLocComponent(FLabelCaption).FComponentStyle, csSubComponent);

  FColorActive:=$00F4F4F4;
  FColorDeActive:=clSilver;
end;
destructor TAmTabCustom.Destroy;
begin
   if Assigned(FSplit) then
   FreeAndNil(FSplit);
   inherited;
end;
function TAmTabCustom.GetCaption:string;
begin
    Result:=FCaptionText;
end;
procedure TAmTabCustom.SetCaption(V:string);
begin
   FCaptionText:= V;
   inherited Caption:='';
   self.Realign;
end;

procedure TAmTabCustom.Paint;

begin
    inherited Paint;
    if  Assigned(FPage)
    and Assigned(FPage.PageControl)
    and Assigned(FSplit) and (FSplit.Width>0) then
    PaintSplit;
end;
procedure TAmTabCustom.PaintSplit;
var R:TRect;
begin

          Canvas.Pen.Assign(FSplit);
          R:= self.ClientRect;

        if  FPage.PageControl.TabsIsTop then
        begin
          Canvas.MoveTo(R.Width-1,2);
          Canvas.LineTo(R.Width-1,R.Height-2);
        end
        else
        begin
          Canvas.MoveTo(2,R.Height-1);
          Canvas.LineTo(R.Width-1,R.Height -1);
        end;

end;
procedure TAmTabCustom.SetPage(APage: TAmPageCustom);
begin
   FPage:= APage;
end;
procedure TAmTabCustom.SetParent(W:TWinControl);
begin
    inherited;
    if W=nil then  exit;
    FLabelCaption.Parent:=self;


end;
procedure TAmTabCustom.SetName(const AName: TComponentName);
begin
    inherited;
    FLabelCaption.Name:= 'LabelCaption';
    inherited Caption:='';
end;
procedure TAmTabCustom.Resize;
begin
   inherited Resize;
end;
procedure TAmTabCustom.AlignControls(AControl: TControl; var Rect: TRect);
var Cap:string;
siz:TSize;
r:boolean;
begin
  if FLabelCaption.Parent<>nil then
  begin
   Cap:=  FCaptionText;
   siz:= FLabelCaption.Canvas.TextExtent(Cap);
   FLabelCaption.Left:= Rect.Left+5;
   FLabelCaption.Top:= (Rect.Height div 2)  - (siz.cy div 2);


      r:=false;
      while (siz.Width >= Rect.Width) and (length(Cap)>0) do
       begin
        delete(Cap,length(Cap),length(Cap));
        siz:= FLabelCaption.Canvas.TextExtent(Cap);
        r:=true;
       end ;
       if r and (length(Cap)>=1) then
       Cap:=Cap+'Е'
       else if r then Cap:='';
            

       FLabelCaption.Caption :=Cap;

  end
  else inherited;

end;
procedure TAmTabCustom.CMMouseLeave(var Message: TMessage); //message CM_MOUSELEAVE;
begin
   inherited;
  MouseLeave;
end;
procedure TAmTabCustom.CMMouseEnter(var Message: TMessage);// message CM_MOUSEENTER;
begin
   inherited;
   MouseEnter;
end;
procedure  TAmTabCustom.MouseLeave;
begin
    if Assigned(Page) then
    Page.TabMouseLeave(self);
end;
procedure  TAmTabCustom.MouseEnter;
begin
    if Assigned(Page) then
    Page.TabMouseEnter(self);
end;
procedure TAmTabCustom.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    if Assigned(Page) then
    Page.TabMouseDown(self,Button,Shift, X, Y);
end;
procedure TAmTabCustom.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    if Assigned(Page) then
    Page.TabMouseUp(self,Button,Shift, X, Y);
end;
procedure TAmTabCustom.MouseMove(Shift: TShiftState; X,Y: Integer);
begin
  inherited;
    if Assigned(Page) then
    Page.TabMouseMove(self,Shift, X, Y);
end;
procedure TAmTabCustom.Click;
begin
    inherited;
    TabClick;
end;
procedure TAmTabCustom.PageCaptionClick(S:TObject);
begin
    TabClick;
end;
procedure TAmTabCustom.TabClick;
begin
    if Assigned(FPage) and Assigned(FPage.FPageControl) then
    FPage.FPageControl.TabsClickChange(FPage);
end;
procedure TAmTabCustom.SetColorActive(V:TColor);
begin
   FColorActive:=V;
   if Assigned(FPage) then
   FPage.DrawTab;
end;
procedure TAmTabCustom.SetColorDeActive(V:TColor);
begin
  FColorDeActive:=V;
   if Assigned(FPage) then
   FPage.DrawTab;
end;






{ TAmPageCustom }
constructor TAmPageCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabIndexDesign:=-1;
  FTab := GetClassTab.Create(self);
  FTab.SetPage(self);
  FPageControl := nil;
  FPageIndex := -1;
  Visible:=false;
  FIsOptionDefault:=true;
  Include(FTab.FComponentStyle, csSubComponent);
  self.ShowCaption:=false;
end;

destructor TAmPageCustom.Destroy;
begin
  // FTabVisible:=false;
  PageControl := nil;
  inherited;
end;
procedure TAmPageCustom.SetName(const AName: TComponentName);
begin
    inherited;
    FTab.Name:='Tab';
    if FTab.Caption='' then     
    FTab.Caption:=self.Name;
    Caption:='';

end;
procedure TAmPageCustom.TabMouseDown(Initiator:TControl;Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(self.PageControl) then
    PageControl.TabMouseDown(self,Initiator,Button,Shift,X, Y);
end;
procedure TAmPageCustom.TabMouseUp(Initiator:TControl;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(self.PageControl) then
    PageControl.TabMouseUp(self,Initiator,Button,Shift,X, Y);
end;
procedure TAmPageCustom.TabMouseMove(Initiator:TControl;Shift: TShiftState; X,Y: Integer);
begin
    if Assigned(self.PageControl) then
    PageControl.TabMouseMove(self,Initiator,Shift,X, Y);
end;
procedure TAmPageCustom.TabMouseLeave(Initiator:TControl);
begin
    if Assigned(self.PageControl) then
    PageControl.TabMouseLeave(self,Initiator);
end;
procedure TAmPageCustom.TabMouseEnter(Initiator:TControl);
begin
     if Assigned(self.PageControl) then
    PageControl.TabMouseEnter(self,Initiator);
end;
procedure TAmPageCustom.PageControlRemove(F: TAmPageControlCustom);
var
NextPage: TAmPageCustom;
begin
    if FPageControl = nil then
      Exit;

    NextPage:=nil;
    if self = FPageControl.ActivePage then
    NextPage := FPageControl.FindNextPage(self, FPageIndex<>FPageControl.PageCount-1,
      not(csDesigning in ComponentState));


    if NextPage = self then
      NextPage := nil;
    // Page.SetTabShowing(False);
    Visible:=false;
    Parent :=nil;
    Tab.Parent:=nil;
    FPageControl.FPages.Remove(self);

    if self = FPageControl.ActivePage then
    FPageControl.SetActivePage(NextPage)
    else self.Visible:=false;
    FPageControl.TabsUpdate;
    FPageControl := nil;
    FPageIndex:=-1;
end;
procedure TAmPageCustom.PageControlInsert(F: TAmPageControlCustom);
begin

    if F = nil then
    begin
      Visible:=false;
      Parent :=nil;
      Tab.Parent:=nil;
      Exit;
    end;

  F.InsertNewPage(self);
  Tab.Parent := F.TabsPanel;

  Tab.Visible:=true;
  Parent := F;
  Align := alClient;
  Visible:=false;
  self.SendToBack;

  if IsOptionDefault then
  begin
    if Assigned(F.TabsSplit) and Assigned(Tab.Split) then
    Tab.Split.Assign(F.TabsSplit)
    else
    begin
        if Assigned(Tab.Split) then
        begin
           Tab.Split.Free;
           Tab.FSplit:=nil;
        end;
    end;
    if Assigned(F.TabsFont) and Assigned(Tab.LabelCaption) then
    Tab.LabelCaption.Font.Assign(F.TabsFont);

    Color:=Color;
    Tab.ColorActive:=  F.TabsActiveColor;
    Tab.ColorDeActive:= F.TabsDeActiveColor;
  end;
  //Color:=random(111255);
end;
procedure TAmPageCustom.SetPageControl(F: TAmPageControlCustom);
begin
  if FPageControl = F then
    Exit;
    PageControlRemove(F);
    PageControlInsert(F);
    if Assigned(F) then
    F.TabsUpdate;
end;
procedure TAmPageCustom.SetTabIndexDesign(index:integer);
begin
  if (csLoading in self.ComponentState)
  //or (csDesigning in self.ComponentState)
  then
  begin
     FTabIndexDesign:=index;
  end
  else
  begin
    FTabIndexDesign:=index;
    if not Assigned(PageControl) then exit;
    if index>= PageControl.PageCount then
    index:=  PageControl.PageCount-1;
    if index<0 then exit;
    if FTabIndexDesign=index  then  exit;
    if FPageIndex<0  then  exit;

    PageControl.FPages.Exchange(FPageIndex,index);

    PageControl.TabsUpdate;
  end;

end;
procedure TAmPageCustom.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TAmPageControlCustom then
    PageControl := TAmPageControlCustom(Reader.Parent);


end;

procedure TAmPageCustom.Paint;
begin
    inherited;
end;
procedure TAmPageCustom.DrawTab;
begin
  if not  Assigned(FPageControl) then exit;

  if FPageControl.ActivePage = self then
  begin
    if Tab.Parent<>nil then
    Tab.Color:=Tab.ColorActive;

  end
  else
  begin
    if Tab.Parent<>nil then
    Tab.Color:=Tab.ColorDeActive;
  end;
 // Tab.Caption:=self.Name;
  Caption:= self.Name +' PageIndex:'+ PageIndex.ToString;
end;

function  TAmPageCustom.GetClassTab: TAmTabClass;
begin
    Result:= TAmTabCustom;
end;

{ TLocPanel }
constructor TLocPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.ParentBackground := false;
  self.BevelOuter := bvNone;
end;

end.



