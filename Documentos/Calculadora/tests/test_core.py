from calculadora.core import Calculadora
import pytest


@pytest.fixture
def calc():
    return Calculadora()

def test_adicao(calc):
    assert calc.somar(2, 3) == 5

def test_subtracao(calc):
    assert calc.subtrair(5, 3) == 2

def test_multiplicacao(calc):
    assert calc.multiplicar(4, 3) == 12

def test_divisao(calc):
    assert calc.dividir(10, 2) == 5

def test_divisao_por_zero(calc):
    with pytest.raises(ValueError):
        calc.dividir(5, 0)

def test_potencia(calc):
    assert calc.potencia(2, 3) == 8
    assert calc.potencia(2, 0) == 1
    assert calc.potencia(2, -2) == 0.25

def test_fatorial(calc):
    assert calc.fatorial(5) == 120
    assert calc.fatorial(0) == 1

def test_fatorial_negativo(calc):
    with pytest.raises(ValueError):
        calc.fatorial(-3)
