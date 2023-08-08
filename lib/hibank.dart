import 'dart:io';
import 'dart:math';

void execute() {
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

  bool sair = false;
  while (!sair) {
    var menu = '1 - Depositar\n2 - Sacar\n3 - Saldo\n4 - Extrato\n5 - Pŕevia de rendimento/transferência\n0 - Sair';
    stdout.writeln(menu);
    int? opcao = int.tryParse(stdin.readLineSync() ?? '');
    if (opcao == null || ![0, 1, 2, 3, 4, 5].contains(opcao)) {
      stdout.writeln("Digite uma opção válida.");
    }
    else {
      if (opcao == 0) {
        sair = true;
      }else {
        bool confirmaSenha = false;
        while (!confirmaSenha) {
          stdout.writeln("Antes é necessario inserir sua senha para confirmar a operação:");
          int senhaOperacao = int.tryParse(stdin.readLineSync()??"")!;
          confirmaSenha = conta.confirmaSenha(senhaOperacao);
        }
        switch (opcao) {
          case 1:
            stdout.writeln("Qual valor do depósito na conta ${conta.conta}?");
            double? deposito = double.tryParse(stdin.readLineSync()??"");
            if (deposito != null && deposito > 0) {
              // bool confirmaSenha = false;
              // while (!confirmaSenha) {
              //   stdout.writeln("Antes é necessario inserir sua senha para confirmar a operação:");
              //   int senhaOperacao = int.tryParse(stdin.readLineSync()??"")!;
              //   confirmaSenha = conta.confirmaSenha(senhaOperacao);
              // }
              conta.depositar(deposito);
              stdout.writeln("Depósito realizado com sucesso!\nSeu saldo atual é ${conta.saldo}");
            }
          case 2:
            stdout.writeln("Qual valor do saque na conta ${conta.conta}?");
            double? saque = double.tryParse(stdin.readLineSync()??"");
            if (saque != null && saque > 0) {
              // bool confirmaSenha = false;
              // while (!confirmaSenha) {
              //   stdout.writeln("Antes é necessario inserir sua senha para confirmar a operação:");
              //   int senhaOperacao = int.tryParse(stdin.readLineSync()??"")!;
              //   confirmaSenha = conta.confirmaSenha(senhaOperacao);
              // }
              conta.sacar(saque);
            }
            stdout.writeln("Saque realizado com sucesso!\nSeu saldo atual é ${conta.saldo}");
          case 3:
            stdout.writeln("Seu saldo atual é de: ${conta.saldo}");
          case 4:
            stdout.writeln("Seu extrato total:\n${conta.extratoStr()}");
          case 5:
            if (conta.tipo == 2) {
              stdout.writeln("Conta Poupança - Prévia de rendimento");
              stdout.writeln("Em quanto tempo (meses) deseja o retorno do investimento?");
              int? meses = int.tryParse(stdin.readLineSync()??'');
              if (meses !=null && meses <= 24) {
                double saldo = conta.saldo;
                for (var i = 0; i < meses; i++) {
                  saldo *= 1.02;
                  stdout.writeln("Seu saldo após o ${i+1}º mês: $saldo");
                }
                stdout.writeln("Seu rendimento total ao final dos $meses seria de: ${saldo-conta.saldo}");
              } else {
                stdout.writeln("Valor inválido para previsão!\n");
              }
            } else {
              stdout.writeln("Conta Corrente - área de transferência\n");
              stdout.writeln("Para quem/qual conta deseja transferir?");
              String? contaDestino = stdin.readLineSync();
              stdout.writeln("Qual valor deseja transferir para $contaDestino?");
              double? valorDestino = double.tryParse(stdin.readLineSync()??"");
              if (contaDestino != null && valorDestino != null) {
                conta.transferir(valorDestino, contaDestino);
              }
              stdout.writeln("Transferência concluída com sucesso!");
            }

        }
      }
    }

  }

}


class Conta {
  final String conta;
  final int tipo;
  double saldo = 0.0;
  final int senha;
  List<String> extrato = [];
  

  Conta(this.conta, this.senha, this.tipo){
    setSaldo(0.0, 'Saldo inicial');
    print('Voce criou a conta $conta do tipo ${contaStr()} com a senha $senha\nSeu saldo atual é $saldo');
  }

  String contaStr(){
    print(tipo);
    return tipo == 1? "Corrente" : "Poupança";
  }

  void setSaldo(double valor, String operacao) {
    var novoSaldo = saldo! + valor;
    extrato.add('$operacao no valor de $valor. Novo saldo de: $novoSaldo');
    saldo = novoSaldo;
  }

  void depositar(double valor) {
    setSaldo(valor, 'DEPOSITO');
  }

  void sacar(double valor) {
    setSaldo(-valor, 'SAQUE');
  }

  void transferir(double valor, String destino) {
    setSaldo(-valor, "TRANSFERENCIA para $destino");
  }

  String extratoStr(){
    return extrato.join("\n");
  }

  bool confirmaSenha(int s) {
    if (s == senha) {return true;}
    else {return false;}
  }

}