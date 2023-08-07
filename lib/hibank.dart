import 'dart:io';
import 'dart:math';

Conta execute() {
  stdout.writeln('Escolha um nome para sua conta:');
  var nome = stdin.readLineSync();
  stdout.writeln('Escolha um tipo para sua conta: 1 - Corrente e 2 - Poupança');
  bool tipo_valido = false;
  String senha = "";
  int tipo = 0;
  while (!tipo_valido) {
    tipo = int.parse(stdin.readLineSync()!.trim());
    print('$tipo, $tipo_valido');
    if ([1, 2].contains(tipo)){
      print('ENTROU NO IF com tipo: $tipo');
      tipo_valido = true;
    }
  }
  stdout.writeln('Escolha uma senha de 8 dígitos para sua conta:');
  bool senha_valida = false;
  while (!senha_valida) {
    senha = stdin.readLineSync()!.trim();
    if (senha.length == 8) {
      senha_valida = true;
    }
  }
  var conta = Conta(nome!, int.parse(senha), tipo);

  int opcao = 6;
  while (opcao != 0 ) {
    stdout.writeln('Escolha uma opção: \n1 - Depositar\n2 - Sacar\n3 -Saldo\n4 -Extrato\n5 -Pŕevia de rendimento/transferência');
    // opcao = int.parse(stdin.readLineSync());
  }

  return conta;
}

class Conta {
  final String conta;
  final int tipo;
  late double saldo;
  final int senha;
  late List<String> extrato;
  
  String contaStr(){
    print(this.tipo);
    return this.tipo == 1? "Corrente" : "Poupança";
  }

  void setSaldo(double valor, String operacao) {
    var novoSaldo = saldo + valor;
    extrato.add('$operacao no valor de $valor. Novo saldo de: $novoSaldo');
    saldo = novoSaldo;
  }

  void depositar(double valor) {
    setSaldo(valor, 'DEPOSITO');
  }

  void sacar(double valor) {
    setSaldo(-valor, 'SAQUE');
  }

  Conta(this.conta, this.senha, this.tipo){
    setSaldo(0.0, 'Saldo inicial');
    print('Voce criou a conta ${this.conta} do tipo ${this.contaStr()} com a senha ${this.senha}\nSeu saldo atual é ${this.saldo}');
  }

}