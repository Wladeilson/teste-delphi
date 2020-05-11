unit Ex2EntidadesCalc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DB, DBClient, FMTBcd, Provider,
  SqlExpr, Grids, DBGrids, Mask, DBCtrls;

type
  TEx2EntidadesCalcF = class(TForm)
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    btnNovo: TButton;
    cdsAux: TClientDataSet;
    dsPrincipal: TDataSource;
    cdsFuncionario: TClientDataSet;
    dsFuncionario: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    dbedtNOME: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    btnRemover: TButton;
    cdsDependente: TClientDataSet;
    cdsFuncionarioID_FUNCIONARIO: TIntegerField;
    cdsFuncionarioNOME: TStringField;
    cdsFuncionarioCPF: TStringField;
    cdsFuncionarioVL_SALARIO: TFloatField;
    cdsFuncionarioqrDependente: TDataSetField;
    grpDependentes: TGroupBox;
    DBGrid2: TDBGrid;
    dsDependente: TDataSource;
    btnNovoDependente: TButton;
    btnRemoverDependente: TButton;
    Label5: TLabel;
    DBEdit2: TDBEdit;
    Label6: TLabel;
    dbedtNOME_DEPENDENTE: TDBEdit;
    cdsDependenteID_DEPENDENTE: TIntegerField;
    cdsDependenteNOME: TStringField;
    cdsDependenteBO_CALCULA_IR: TStringField;
    cdsDependenteBO_CALCULA_INSS: TStringField;
    cdsDependenteID_FUNCIONARIO: TIntegerField;
    dbchkCALCULA_IR: TDBCheckBox;
    dbchkCALCULA_INSS: TDBCheckBox;
    medtVlIR: TMaskEdit;
    medtVlINSS: TMaskEdit;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnNovoDependenteClick(Sender: TObject);
    procedure btnRemoverDependenteClick(Sender: TObject);
    procedure cdsDependenteAfterInsert(DataSet: TDataSet);
    procedure cdsFuncionarioAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Ex2EntidadesCalcF: TEx2EntidadesCalcF;

implementation

uses MenuPrincipal, FuncionarioU, unitFuncoes, ConnectionDM;

var
  Funcionario: TFuncionario;
  Dependente: TDependente;  

{$R *.dfm}

//Exerc�cio 2 � Entidades de c�lculo.

//* Criar uma classe Funcion�rio com as seguintes propriedades
//	* (Nome, CPF, Sal�rio)

//* Criar uma classe Dependente com as seguintes propriedades
//	* (Nome, IsCalculaIR, IsCalculaINSS)

//* A classe de Funcionario ter� uma lista de dependentes

//* C�lculo de INSS e IR aplicado ao funcion�rio usando o valor do sal�rio como base.
//	* Regras de neg�cio
//		* INSS - O c�lculo de INSS ser� descontado 8% do valor do funcion�rio caso
// o dependente calcula INSS
//		* IR � O c�lculo de IR ser� deduzido da base, sal�rio 100 reais para cada

//dependente que possuir calcula IR e por fim desconta 15% do sal�rio do funcion�rio.
//		* Ex. Funcion�rio que ganha 1000,00 e que tenha dois dependentes onde o IsCalculaIR e IsCalculaINSS estejam marcados.
//		* INSS = 1000,00 � 8% = 80,00
//		* IR = 1000,00 - (2 * 100) = 800,00 � 15% = 120,00.

//* Criar a mesma estrutura em um banco de dados e gravar as informa��es usando uma camada de banco de dados para o acesso

//* O sistema dever� ser desenvolvido na plataforma delphi,
//(banco de dados prefer�ncialmente firebird, caso for usado outro banco, informar no pull-request e enviar os scripts para cria��o do mesmo)
//
//
//obs: Teste ter� como avalia��o principal os requisitos solicitados nos exerc�cios,  por�m os testes
//poder� ser crit�rio de desempate.

procedure TEx2EntidadesCalcF.FormShow(Sender: TObject);
var i:Integer;
begin
  try
   with ConnectionDMF do
   begin
    SQLConn.Close;
    SQLConn.Open;
   end;

   cdsFuncionario.Close;
   cdsFuncionario.Open;
   FormataCampos(cdsFuncionario,nil);
   FormataCampos(cdsDependente,nil);
  except
    on e:Exception do
    begin
      Mensagem('<< Banco de Dados inv�lido ou conex�o inexistente >>'
          +#13+''
          +#13+'Motivo: '+e.Message
          +#13+'Por favor, verifique:'
          +#13+'- Se o servidor "Firebird" est� em execu��o.'
          +#13+'- Se o arquivo de banco � um formato ".fdb" v�lido.'
          +#13+'- Se o Usu�rio e senha do banco est�o corretos.'          
          ,self,1);
    end;
  end;
end;

procedure TEx2EntidadesCalcF.btnCancelarClick(Sender: TObject);
begin
  if Pergunta('Deseja realmente cancelar as altera��es?', Self) then
  begin
    cdsFuncionario.CancelUpdates;
    Close;
  end;
end;

procedure TEx2EntidadesCalcF.btnSalvarClick(Sender: TObject);
begin
  cdsFuncionario.ApplyUpdates(0);
  Close;
end;

procedure TEx2EntidadesCalcF.btnNovoClick(Sender: TObject);
begin                                                                                                                     
  with cdsFuncionario do
  begin
    Insert;
    FieldByName('ID_FUNCIONARIO').AsInteger := Proximo('FUNCIONARIO', 'ID_FUNCIONARIO');
    dbedtNOME.SetFocus;
  end;   
end;

procedure TEx2EntidadesCalcF.btnRemoverClick(Sender: TObject);
begin
  if Pergunta('Deseja realmente remover esse Funcionario(a)?', SElf) then
  begin
    cdsFuncionario.Delete;
  end;
end;

procedure TEx2EntidadesCalcF.btnNovoDependenteClick(Sender: TObject);
begin
  with cdsDependente do
  begin
    Insert;
    FieldByName('ID_DEPENDENTE').AsInteger := ProximoFilho('DEPENDENTE', 'ID_DEPENDENTE', 'ID_FUNCIONARIO', cdsFuncionario.fieldbyName('ID_FUNCIONARIO').AsString);
    dbedtNOME_DEPENDENTE.SetFocus;
  end;
end;

procedure TEx2EntidadesCalcF.btnRemoverDependenteClick(Sender: TObject);
begin
  if Pergunta('Deseja realmente remover esse Dependente?', SElf) then
  begin
    cdsDependente.Delete;
  end;
end;

procedure TEx2EntidadesCalcF.cdsDependenteAfterInsert(DataSet: TDataSet);
begin
  cdsDependente.FieldByName('BO_CALCULA_IR').AsString := 'NAO';
  cdsDependente.FieldByName('BO_CALCULA_INSS').AsString := 'NAO';  
end;

procedure TEx2EntidadesCalcF.cdsFuncionarioAfterScroll(DataSet: TDataSet);
var vIsCalculaIR, vIsCalculaINSS :Boolean;
begin
  with Funcionario do
  begin
    IdFuncionario := TClientDataSet(DataSet).FieldByName('ID_FUNCIONARIO').AsInteger;
    Nome          := TClientDataSet(DataSet).FieldByName('NOME').AsString;
    CPF           := TClientDataSet(DataSet).FieldByName('CPF').AsString;
    Salario       := TClientDataSet(DataSet).FieldByName('VL_SALARIO').AsFloat;

    Dependentes.Clear;
    with cdsDependente do
    begin
      DisableControls;
      First;
      while not Eof do
      begin
        vIsCalculaIR   := FieldByName('BO_CALCULA_IR').AsString = 'SIM';
        vIsCalculaINSS := FieldByName('BO_CALCULA_INSS').AsString = 'SIM';
        Dependentes.Add(TDependente.Create(FieldByName('ID_DEPENDENTE').AsInteger
                                          ,FieldByName('NOME').AsString
                                          ,vIsCalculaIR
                                          ,vIsCalculaINSS
                                          ,FieldByName('ID_FUNCIONARIO').AsInteger));
        Next;                                          
      end;
      First;
      EnableControls;
    end;

    medtVlIR.Text := FloatToStr(CalculaIR);
    medtVlINSS.Text := FloatToStr(CalculaINSS);
  end;
end;

procedure TEx2EntidadesCalcF.FormCreate(Sender: TObject);
begin
  Funcionario := TFuncionario.Create();
end;

end.
