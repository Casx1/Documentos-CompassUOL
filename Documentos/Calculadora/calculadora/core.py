class Calculadora:

    @staticmethod
    def somar(a, b):
        return a + b

    @staticmethod
    def subtrair(a, b):
        return a - b

    @staticmethod
    def multiplicar(a, b):
        return a * b

    @staticmethod
    def dividir(a, b):
        if b == 0:
            raise ValueError("Divisão por zero não é permitida.")
        return a / b

    @staticmethod
    def potencia(base, expoente):
        resultado = 1
        for _ in range(abs(expoente)):
            resultado *= base
        return resultado if expoente >= 0 else 1 / resultado

    @staticmethod
    def fatorial(n):
        if n < 0:
            raise ValueError("Fatorial não definido para números negativos.")
        resultado = 1
        for i in range(1, n + 1):
            resultado *= i
        return resultado
