unit Ex2EntidadesCalc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TEx2EntidadesCalcF = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Ex2EntidadesCalcF: TEx2EntidadesCalcF;

implementation

uses MenuPrincipal;

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

procedure TEx2EntidadesCalcF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MenuPrincipalF.fecharForm(self, key);
end;

end.
