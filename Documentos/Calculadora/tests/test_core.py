from calculadora.core import Calculadora
import pytest

def test_adicao():
    assert Calculadora.somar(2, 3) == 5

def test_subtracao():
    assert Calculadora.subtrair(5, 3) == 2

def test_multiplicacao():
    assert Calculadora.multiplicar(4, 3) == 12

def test_divisao():
    assert Calculadora.dividir(10, 2) == 5

def test_divisao_por_zero():
    with pytest.raises(ValueError):
        Calculadora.dividir(5, 0)

def test_potencia():
    assert Calculadora.potencia(2, 3) == 8
    assert Calculadora.potencia(2, 0) == 1
    assert Calculadora.potencia(2, -2) == 0.25

def test_fatorial():
    assert Calculadora.fatorial(5) == 120
    assert Calculadora.fatorial(0) == 1

def test_fatorial_negativo():
    with pytest.raises(ValueError):
        Calculadora.fatorial(-3)
