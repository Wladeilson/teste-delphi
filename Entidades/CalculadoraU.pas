unit CalculadoraU;

interface

  uses StrUtils;

type
  TOperacao = (opIsNull, opDividir, opMultiplicar, opSubtrair, opSomar, opIgual);
  TCalculadora = class
    //procedure teste(Sender: TObject);
  private
    vnumeroA: Real;
    vtemNumeroA:Boolean;

    vtemNumeroB:Boolean;
    vnumeroB: Real;

    vResultado: Real;

    voperacao: TOperacao;
    vUltimaOperacao :TOperacao;
    vHistoricoCalculo: String;

    vEhPrimeiraVez: Boolean;

    procedure setnumeroA(pnumeroA:String);
    procedure setnumeroB(pnumeroB:String);
    procedure setEhPrimeiraVez(pEhPrimeiraVez:Boolean);    

    function somar(pnumeroA: Real; pnumeroB: Real):Boolean;
    function subtrair(pnumeroA: Real; pnumeroB: Real):Boolean;
    function dividir(pnumeroA: Real; pnumeroB: Real):Boolean;
    function multiplicar(pnumeroA: Real; pnumeroB: Real):Boolean;

    procedure setResultado(pvalor:Real);
    procedure setHistoricoCalculo(pvalor: String);
    procedure setUltimaOperacao(poperacao:TOperacao);
    { Private declarations }
    
  public
    function calcular(pNumeroVisor:String; pOperacaoAtual :TOperacao; var pHistoricoCalculo:String):Real;

    function temNumeroA():Boolean;
    function getnumeroA:Real;
    function getnumeroAtoString:String;


    function temNumeroB():Boolean;
    function getnumeroB:Real;
    function getnumeroBtoString:String;


    function getResultado():Real;
    function getResultadotoString():String;

    procedure setOperacao(poperacao:TOperacao);
    function getOperacao:TOperacao;

    function getUltimaOperacao:TOperacao;
    function getOperacaoToString(poperacao:TOperacao):String;
    function getOperacaoToConvert(poperacao:String):TOperacao;

    function getHistoricoCalculo:string;
    function ehPrimeiraVez():Boolean;
    constructor create();
    { Public declarations }
  end;


implementation

uses Variants, SysUtils;

{ TCalculadora }

constructor TCalculadora.create;
begin
  vtemNumeroA := False;
  vtemNumeroB := False;
  vEhPrimeiraVez := true;
end;

function TCalculadora.getHistoricoCalculo: string;
begin
  result := vHistoricoCalculo;
end;

function TCalculadora.getnumeroAtoString: String;
begin
  result := FloatToStr(vnumeroA);
end;

function TCalculadora.getnumeroBtoString: String;
begin
  result := FloatToStr(vnumeroB);
end;

function TCalculadora.getOperacao: TOperacao;
begin
  Result := voperacao;
end;

procedure TCalculadora.setnumeroA(pnumeroA: String);
begin
  if pnumeroA <> '' then
  begin
    vnumeroA := StrToFloat(pnumeroA);
    vtemNumeroA := True;
  end;
end;

procedure TCalculadora.setnumeroB(pnumeroB: String);
begin
  if pnumeroB <> '' then
  begin
    vnumeroB := StrToFloat(pnumeroB);
    vtemNumeroB := True;
  end;
end;

procedure TCalculadora.setOperacao(poperacao: TOperacao);
begin
  voperacao := poperacao;
end;

function TCalculadora.somar(pnumeroA: Real; pnumeroB: Real): Boolean;
begin
  if temNumeroA() and temNumeroB() then
  begin
    //SOMAR
    setResultado(pnumeroA + pnumeroB);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao)
                        +FloatToStr(pnumeroB)
                        +getOperacaoToString(getUltimaOperacao));
    Result := True;
  end else
  begin
    setResultado(pnumeroA);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao));
    Result := false;
  end;
end;

function TCalculadora.subtrair(pnumeroA: Real; pnumeroB: Real): Boolean;
begin
  if temNumeroA() and temNumeroB() then
  begin
    //SUBTRAIR
    setResultado(pnumeroA - pnumeroB);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao)
                        +FloatToStr(pnumeroB)
                        +getOperacaoToString(getUltimaOperacao));
    Result := True;
  end else
  begin
    setResultado(pnumeroA);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao));
    Result := false;
  end;
end;

function TCalculadora.dividir(pnumeroA: Real; pnumeroB: Real): Boolean;
begin
  if temNumeroA() and temNumeroB() then
  begin
    if pnumeroB = 0 then
    begin
      Result := false;
      setResultado(pnumeroB);
      setHistoricoCalculo('ERRO: Imposs�vel dividir por zero!');
      vtemNumeroA := False;
      vtemNumeroB := False;
      Exit;
    end;
      
    //DIVIDIR
    setResultado(pnumeroA / pnumeroB);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao)
                        +FloatToStr(pnumeroB)
                        +getOperacaoToString(getUltimaOperacao));
    Result := True;
  end else
  begin
    setResultado(pnumeroA);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao));
    Result := false;
  end;
end;

function TCalculadora.multiplicar(pnumeroA: Real; pnumeroB: Real): Boolean;
begin
  if temNumeroA() and temNumeroB() then
  begin
    //MULTIPLICAR
    setResultado(pnumeroA * pnumeroB);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao)
                        +FloatToStr(pnumeroB)
                        +getOperacaoToString(getUltimaOperacao));
    Result := True;
  end else
  begin
    setResultado(pnumeroA);
    setHistoricoCalculo(FloatToStr(pnumeroA)
                        +getOperacaoToString(getOperacao));
    Result := false;
  end;
end;

function TCalculadora.temNumeroA: Boolean;
begin
  Result := vtemNumeroA;
end;

function TCalculadora.temNumeroB: Boolean;
begin
  Result := vtemNumeroB;
end;

function TCalculadora.ehPrimeiraVez: Boolean;
begin
  Result := vEhPrimeiraVez;
end;

procedure TCalculadora.setEhPrimeiraVez(pEhPrimeiraVez: Boolean);
begin
  vEhPrimeiraVez := pEhPrimeiraVez;
end;

function TCalculadora.getUltimaOperacao: TOperacao;
begin
  result := vUltimaOperacao;
end;

procedure TCalculadora.setUltimaOperacao(poperacao: TOperacao);
begin
  vUltimaOperacao := poperacao;
end;

function TCalculadora.getOperacaoToString(
  poperacao: TOperacao): String;
begin
  case poperacao of
    opSomar:       result := '+';
    opSubtrair:    result := '-';
    opMultiplicar: result := 'x';
    opDividir:     result := '/';
    opIgual:       result := '=';
    opIsNull:      result := 'IsNull';        
  end;
end;

function TCalculadora.getnumeroA: Real;
begin
  result := vnumeroA;
end;

function TCalculadora.getnumeroB: Real;
begin
  Result := vnumeroB;
end;

function TCalculadora.getResultado: Real;
begin
  result := vResultado;
end;

function TCalculadora.getResultadotoString: String;
begin
  result := FloatToStr(vResultado);
end;

procedure TCalculadora.setResultado(pvalor: Real);
begin
  vResultado := pvalor;
end;

procedure TCalculadora.setHistoricoCalculo(pvalor: String);
begin
  vHistoricoCalculo := pvalor;
end;

function TCalculadora.calcular(pNumeroVisor:String; pOperacaoAtual :TOperacao; var pHistoricoCalculo:String): Real;
var vlcalculou:Boolean;
    vlNumeroA, vlNumeroB :Real;
begin
  //wlad: Elaborar algor�timo para calculadora padr�o de mesa e de computador.

//* Quando digitarmos um n�mero e escolhermos uma opera��o, a calculadora checa se � a primeira vez.
//	* Se for, o resultado � o n�mero do visor.

//* Conforme trocamos, as opera��es s�o executadas, o valor � armazenado e a opera��o � atualizada.

//* Ao clicar em igual, checamos se � a primeira vez.
//	* Se for, executamos a �ltima opera��o com o n�mero do visor.

//	* Caso n�o seja, a opera��o ser� executada, mas usamos o que guardamos do visor no primeiro clique de igual.
//    Isso permite que fa�amos 5 / 5 * 2 (igual, igual).

//

  //gravar as opera��es, exceto a opera��o "=", para saber qual foi a ultima opera��o calculada
  if (pOperacaoAtual <> opIgual)then
    setOperacao(pOperacaoAtual);

  if (ehPrimeiraVez) then
  begin
    if not temNumeroA then
    begin
      setnumeroA(pNumeroVisor);
    end else
    begin
      setnumeroB(pNumeroVisor);
    end;                                                                 
  end;

  //se digitou a operacao "=" duas vezes seguidas, pega o ultimo resultado e o atual e recalcula com a ultima opera��o
  if (pOperacaoAtual = OpIgual) and (pOperacaoAtual = getUltimaOperacao) then
     setnumeroA(getResultadotoString);

  //se digitou a operacao "=" ou outra opera��o e depois outra operacao,
  //pega o resultado atual como numeroA e aguarde o numeroB (limpe-o);
  if ((getUltimaOperacao = OpIgual)or (getUltimaOperacao <> pOperacaoAtual))
      and (pOperacaoAtual <> opIgual)
      and (getUltimaOperacao <> opIsNull) then
  begin
    setnumeroA(getResultadotoString);
    vtemNumeroB := False;    
  end;     

  vlNumeroA := getnumeroA;
  vlNumeroB := getnumeroB;

//    //se digitou outra operacao e depois "=", pega o ultimo resultado e o atual e recalcula com a nova opera��o
//    if (getOperacao <> pOperacaoAtual) and (pOperacaoAtual = OpIgual) then
//    begin
//      vlNumeroA := getResultado;
//      vlNumeroB := getResultado;
//    end;

  setUltimaOperacao(pOperacaoAtual);
  case getOperacao of
    opSomar:
      begin
        vlcalculou := somar(vlNumeroA, vlNumeroB);
      end;

    opSubtrair:
      begin
        vlcalculou := subtrair(vlNumeroA, vlNumeroB);
      end;

    opMultiplicar:
      begin
        vlcalculou := multiplicar(vlNumeroA, vlNumeroB);
      end;

    opDividir:
      begin
        vlcalculou := dividir(vlNumeroA, vlNumeroB);
      end;
  end;

  result := getResultado;
  
  if vlcalculou then
    setEhPrimeiraVez(False);

  pHistoricoCalculo := getHistoricoCalculo;
end;

function TCalculadora.getOperacaoToConvert(poperacao: String): TOperacao;
begin
  case AnsiIndexStr(UpperCase(poperacao), ['+', '-', '/', 'X', '=']) of
    0 : result := opSomar;
    1 : result := opSubtrair;
    2 : result := opDividir;
    3 : result := opMultiplicar;
    4 : result := opIgual;
  end;
end;

end.
