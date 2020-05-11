unit FuncionarioU;

//* Criar uma classe Funcion�rio com as seguintes propriedades
//	* (Nome, CPF, Sal�rio)
//* Criar uma classe Dependente com as seguintes propriedades
//	* (Nome, IsCalculaIR, IsCalculaINSS)
//* A classe de Funcionario ter� uma lista de dependentes

//* C�lculo de INSS e IR aplicado ao funcion�rio usando o valor do sal�rio como base.
// * Regras de neg�cio
// 	* INSS - O c�lculo de INSS ser� descontado 8% do valor do funcion�rio caso o dependente calcula INSS
// 	* IR � O c�lculo de IR ser� deduzido da base, sal�rio 100 reais para cada dependente que possuir calcula IR
//         e por fim desconta 15% do sal�rio do funcion�rio.
// 	* Ex. Funcion�rio que ganha 1000,00 e que tenha dois dependentes onde o IsCalculaIR e IsCalculaINSS estejam marcados.
// 	* INSS = 1000,00 � 8% = 80,00
// 	* IR = 1000,00 - (2 * 100) = 800,00 � 15% = 120,00.
//* Criar a mesma estrutura em um banco de dados e gravar as informa��es usando uma camada de banco de dados para o acesso

interface

uses Classes;


type

  TDependente = class (TList) 
  private
    fIdDependente  :Integer;
    fNome          :String;
    fIsCalculaIR   :Boolean;
    fIsCalculaINSS :Boolean;
    fIdFuncionario :Integer;
  public
    property IdDependente: Integer read fIdDependente write fIdDependente;
    property Nome: String read fNome write fNome;
    property IsCalculaIR: Boolean read fIsCalculaIR write fIsCalculaIR;
    property IsCalculaINSS: Boolean read fIsCalculaINSS write fIsCalculaINSS;
    property IdFuncionario: Integer read fIdFuncionario write fIdFuncionario;    
    constructor create(pIdDependente:Integer; pnome: String; pisCalculaIR, pisCalculaINSS: Boolean; pIdFuncionario:Integer);
  end;

  TFuncionario = class  
  private
    fIdFuncionario : Integer;  
    fnome    :String;
    fcpf     :String;
    fsalario :Real;
    fdependentes :TList;
  public
    property IdFuncionario: Integer read fIdFuncionario write fIdFuncionario;  
    property Nome: String read fNome write fNome;
    property CPF: String read fcpf write fcpf;
    property Salario: Real read fsalario write fsalario;
    property Dependentes: TList read fdependentes write fdependentes;
    constructor create();
    function CalculaIR:Real;
    function CalculaINSS:Real;
  end;

implementation

{ TFuncionario }

function TFuncionario.CalculaINSS: Real;
var vlINSS, vlBase:Real;
    i:Integer;
begin
//* C�lculo de INSS e IR aplicado ao funcion�rio usando o valor do sal�rio como base.
//INSS - O c�lculo de INSS ser� descontado 8% do valor do funcion�rio caso o dependente calcula INSS
// 	* Ex. Funcion�rio que ganha 1000,00 e que tenha dois dependentes onde o IsCalculaIR e IsCalculaINSS estejam marcados.
// 	* INSS = 1000,00 � 8% = 80,00
  vlBase := Salario;
  vlINSS := 0;
  for i := 0 to Dependentes.Count -1 do
  begin
    with TDependente(Dependentes[i])do
    begin
      if IsCalculaINSS then
        vlINSS := vlBase * (8/100);
    end;
  end;
  Result := vlINSS;
end;

function TFuncionario.CalculaIR: Real;
var vlIR, vlBase:Real;
    i:Integer;
begin
//* C�lculo de INSS e IR aplicado ao funcion�rio usando o valor do sal�rio como base.
// 	* IR � O c�lculo de IR ser� deduzido da base, sal�rio 100 reais para cada dependente que possuir calcula IR
//         e por fim desconta 15% do sal�rio do funcion�rio.
// 	* Ex. Funcion�rio que ganha 1000,00 e que tenha dois dependentes onde o IsCalculaIR e IsCalculaINSS estejam marcados.
// 	* IR = 1000,00 - (2 * 100) = 800,00 � 15% = 120,00.
  vlBase := Salario;
  for i := 0 to Dependentes.Count -1 do
  begin
    with TDependente(Dependentes[i])do
    begin
      if IsCalculaIR then
        vlBase := vlBase - 100;
    end;
  end;
  vlIR := vlBase * (15/100);
  Result := vlIR;
end;

constructor TFuncionario.create();
begin
  fdependentes := TList.Create;
end;

{ TDependente }

constructor TDependente.create(pIdDependente:Integer;
                               pnome: String;
                               pisCalculaIR,
                               pisCalculaINSS: Boolean;
                               pIdFuncionario:Integer);
begin
  IdDependente  := pIdDependente;
  Nome          := pnome;
  IsCalculaIR   := pisCalculaIR;
  IsCalculaINSS := pisCalculaINSS;
  IdFuncionario := pIdFuncionario;
end;

end.
