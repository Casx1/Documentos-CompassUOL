from core import Calculadora

class CalculadoraInputInterface:
    def __init__(self):
        self.calc = Calculadora()

    def pedir_entrada(self):
        try:
            operacao = input("Digite a operação:\n"
                             "[1] Somar [2] Subtrair [3] Multiplicar [4] Dividir"
                             "[5] Potencia [6] Fatorial: ").lower()

            if operacao == "fatorial":
                a = int(input("Digite o número para o fatorial: "))
                resultado = self.calc.fatorial(a)
            else:
                a = float(input("Digite o primeiro número: "))
                b = float(input("Digite o segundo número: "))

                operacoes = {
                    "1": self.calc.somar,
                    "2": self.calc.subtrair,
                    "3": self.calc.multiplicar,
                    "4": self.calc.dividir,
                    "5": self.calc.potencia
                }

                if operacao not in operacoes:
                    print("Operação inválida.")
                    return

                resultado = operacoes[operacao](a, b)

            print(f"Resultado: {resultado}")

        except ValueError as e:
            print(f"Erro: {e}")
        except Exception as e:
            print(f"Ocorreu um erro inesperado: {e}")


if __name__ == "__main__":
    interface = CalculadoraInputInterface()
    interface.pedir_entrada()
