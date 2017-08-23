# # Paramètres
# p = 7
# h = 3
# # Représentation
# prime_field = GF(p)
# base_field = GF(p ** 2)
# prime_field_poly = PolynomialRing(prime_field, 'x')
# base_field_poly = PolynomialRing(base_field, 'x')
# Ih, h0, h1 = pick_representation_polynome (p, h, prime_field_poly.gen())
# F = base_field_poly.quotient_ring(Ih)
# # Logarithme des polynômes linéaires F_(p^2)
# linear_poly = [ F.gen() + alp for alp in prime_field ]
# while True :
#     g0 = F.random_element()
#     if is_primitive(g0) :
#         break
# fa = list(factor(p ** (2 * h) - 1))
# loga = [ pohlig_hellman (g0, linear_poly[i], fa) for i in range (p) ]
# # Logarithme des polynômes linéaires F_p
# g = g0 ** (p ** h + 1)
# for i in range (p) :
#     if lift(g ** (loga[i] / 2)).lc() != 1 :
#         loga[i] = ((loga[i] + p ** h - 1) / 2) % (p ** h - 1)
#     else :
#         loga[i] = (loga[i] / 2) % (p ** h - 1)
# # Changement de représentation
# K = GF(p ** h)
# t0 = K(0)
# while True :
#     if prime_field_poly(t0.minpoly()) == Ih :
#         break
#     else :
#         t0 = K.next(t0)
# # Choix de t
# while True :
#     t = K.random_element()
#     if t.minimal_polynomial().degree() == h :
#         break


def pick_representation_polynome (p, h, X) :
    A = X.parent()
    while true :
        h0 = A.random_element(2)
        h0 = h0 - h0(0)
        h1 = A.random_element(1)
        fa = list((h1 * X ** p - h0).factor())
        deg = [ poly.degree() for poly, mult in fa ]
        if h in deg :
            break
    Ih = fa[deg.index(h)][0]
    return Ih, h0, h1

def pohlig_hellman (g, h, fa) :
    n = 1
    for p, i in fa :
        n = n * p ** i
    a = [0 for i in range (len (fa))]
    index = 0
    for p, i in fa :
        for j in range (1, i + 1) :
            g0 = g ** (n / (p ** j))
            h0 = (g0 ** (-a[index])) * (h ** (n / (p ** j)))
            if h0 != 1 :
                g0 = g ** (n / p)
                lg = baby_step_giant_step (g0, h0, p ** j)
                a[index] = a[index] + lg * p ** (j - 1)
        index += 1
    moduli = [ p ** i for p, i in fa ]
    l = CRT (a, moduli)
    return l

def baby_step_giant_step (g, h, n) :
    m = int(ceil (sqrt (n)))
    L = [ g ** i for i in range (m + 1) ]
    u = g ** (-m)
    y = h
    j = 0
    while y not in L :
        y = y * u
        j = j + 1
    return L.index(y) + m * j

def is_primitive (x) :
    A = x.parent()
    card = A.cardinality()
    if card.parent() != ZZ :
        raise ArithmeticError("ring not finite")
    card = card - 1
    for p in prime_factors(card) :
        if x ** (card / p) == A.one() :
            return False
    return True
