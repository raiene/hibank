import 'dart:io';

Conta execute() {
  stdout.writeln('Escolha um nome para sua conta:');
  var nome = stdin.readLineSync();
  stdout.writeln('Escolha um tipo para sua conta: 1 - Corrente e 2 - Poupança');
  bool tipo_valido = false;
  String senha = "";
  int tipo = 0;
  while (!tipo_valido) {
    var tipo = int.parse(stdin.readLineSync()!.trim());
    if ([1, 2].contains(tipo)){
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

  return conta;
}

class Conta {
  late final String nome;
  late final int numero;
  late final int tipo;
  late double saldo;
  final int senha;
  
  Conta(this.nome, this.senha, this.tipo){
    this.saldo = 0.0;
    print('Voce criou a conta $this.nome do tipo ${this.tipo == "1" ? "Corrente" : "Poupança"} com a senha $this.senha\nSeu saldo atual é $this.saldo');
  }

}