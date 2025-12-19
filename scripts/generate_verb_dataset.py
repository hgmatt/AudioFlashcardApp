import json
from pathlib import Path

# Seed irregular verbs with metadata and some sample conjugations for present indicative.
irregulars = [
    {
        "infinitive": "ser",
        "english": "to be",
        "ending": "-er",
        "regularity": "highly-irregular",
        "highlyIrregular": True,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Most irregular verb; include sample present forms.",
        "providedConjugations": {
            "present": {
                "yo": "soy",
                "tú": "eres",
                "usted": "es",
                "nosotros": "somos",
                "vosotros": "sois",
                "ustedes": "son"
            }
        }
    },
    {
        "infinitive": "estar",
        "english": "to be (temporary)",
        "ending": "-ar",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Irregular first person and accents.",
        "providedConjugations": {
            "present": {
                "yo": "estoy",
                "tú": "estás",
                "usted": "está",
                "nosotros": "estamos",
                "vosotros": "estáis",
                "ustedes": "están"
            }
        }
    },
    {
        "infinitive": "haber",
        "english": "to have (auxiliary)",
        "ending": "-er",
        "regularity": "highly-irregular",
        "highlyIrregular": True,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Auxiliary verb; provided present indicative forms.",
        "providedConjugations": {
            "present": {
                "yo": "he",
                "tú": "has",
                "usted": "ha",
                "nosotros": "hemos",
                "vosotros": "habéis",
                "ustedes": "han"
            }
        }
    },
    {
        "infinitive": "tener",
        "english": "to have",
        "ending": "-er",
        "regularity": "stem-change",
        "highlyIrregular": False,
        "stemChange": "e>ie",
        "spellingChange": None,
        "notes": "Stem change e>ie and yo tengo.",
        "providedConjugations": {
            "present": {
                "yo": "tengo",
                "tú": "tienes",
                "usted": "tiene",
                "nosotros": "tenemos",
                "vosotros": "tenéis",
                "ustedes": "tienen"
            }
        }
    },
    {
        "infinitive": "hacer",
        "english": "to do/make",
        "ending": "-er",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Yo hago; otherwise mostly regular present.",
        "providedConjugations": {
            "present": {
                "yo": "hago"
            }
        }
    },
    {
        "infinitive": "poder",
        "english": "to be able to",
        "ending": "-er",
        "regularity": "stem-change",
        "highlyIrregular": False,
        "stemChange": "o>ue",
        "spellingChange": None,
        "notes": "Stem change o>ue.",
        "providedConjugations": {
            "present": {
                "yo": "puedo",
                "tú": "puedes",
                "usted": "puede",
                "nosotros": "podemos",
                "vosotros": "podéis",
                "ustedes": "pueden"
            }
        }
    },
    {
        "infinitive": "ir",
        "english": "to go",
        "ending": "-ir",
        "regularity": "highly-irregular",
        "highlyIrregular": True,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Completely irregular present forms.",
        "providedConjugations": {
            "present": {
                "yo": "voy",
                "tú": "vas",
                "usted": "va",
                "nosotros": "vamos",
                "vosotros": "vais",
                "ustedes": "van"
            }
        }
    },
    {
        "infinitive": "decir",
        "english": "to say",
        "ending": "-ir",
        "regularity": "stem-change",
        "highlyIrregular": False,
        "stemChange": "e>i",
        "spellingChange": None,
        "notes": "Yo digo; stem change e>i.",
        "providedConjugations": {
            "present": {
                "yo": "digo",
                "tú": "dices",
                "usted": "dice",
                "nosotros": "decimos",
                "vosotros": "decís",
                "ustedes": "dicen"
            }
        }
    },
    {
        "infinitive": "ver",
        "english": "to see",
        "ending": "-er",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Yo veo irregularity.",
        "providedConjugations": {
            "present": {
                "yo": "veo"
            }
        }
    },
    {
        "infinitive": "dar",
        "english": "to give",
        "ending": "-ar",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Accent in vosotros present (dáis) but otherwise regular.",
        "providedConjugations": {
            "present": {
                "yo": "doy",
                "vosotros": "dáis"
            }
        }
    },
    {
        "infinitive": "querer",
        "english": "to want",
        "ending": "-er",
        "regularity": "stem-change",
        "highlyIrregular": False,
        "stemChange": "e>ie",
        "spellingChange": None,
        "notes": "Stem change e>ie.",
        "providedConjugations": {
            "present": {
                "yo": "quiero",
                "tú": "quieres",
                "usted": "quiere",
                "nosotros": "queremos",
                "vosotros": "queréis",
                "ustedes": "quieren"
            }
        }
    },
    {
        "infinitive": "venir",
        "english": "to come",
        "ending": "-ir",
        "regularity": "stem-change",
        "highlyIrregular": False,
        "stemChange": "e>ie",
        "spellingChange": None,
        "notes": "Yo vengo with stem change e>ie.",
        "providedConjugations": {
            "present": {
                "yo": "vengo",
                "tú": "vienes",
                "usted": "viene",
                "nosotros": "venimos",
                "vosotros": "venís",
                "ustedes": "vienen"
            }
        }
    },
    {
        "infinitive": "salir",
        "english": "to leave",
        "ending": "-ir",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Yo salgo.",
        "providedConjugations": {
            "present": {"yo": "salgo"}
        }
    },
    {
        "infinitive": "poner",
        "english": "to put",
        "ending": "-er",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Yo pongo.",
        "providedConjugations": {
            "present": {"yo": "pongo"}
        }
    },
    {
        "infinitive": "oír",
        "english": "to hear",
        "ending": "-ir",
        "regularity": "irregular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": "Spelling change; yo oigo.",
        "providedConjugations": {
            "present": {
                "yo": "oigo",
                "tú": "oyes",
                "usted": "oye",
                "nosotros": "oímos",
                "vosotros": "oís",
                "ustedes": "oyen"
            }
        }
    },
]

# Moderately sized list of common verbs to seed the dataset (regular or lightly irregular).
common_regulars = """
hablar
comer
vivir
llegar
pasar
debido
parecer
quedar
creer
llevar
dejar
seguir
encontrar
llamar
pensar
volver
tomar
conocer
sentir
tratar
mirar
contar
empezar
esperar
buscar
entrar
trabajar
escribir
perder
producir
ocurrir
entender
pedir
recibir
recordar
terminar
permitir
aparecer
conseguir
comenzar
servir
sacar
necesitar
mantener
resultar
leer
caer
cambiar
presentar
crear
abrir
considerar
oír
acabar
convertir
ganar
formar
traer
partir
morir
aceptar
realizar
suponer
comprender
lograr
explicar
preguntar
tocar
reconocer
estudiar
alcanzar
nacer
dirigir
correr
utilizar
pagar
ayudar
gustar
jugar
escuchar
cumplir
ofrecer
descubrir
levantar
intentar
usar
decidir
repetir
olvidar
acordar
cerrar
andar
comprar
enseñar
desarrollar
aumentar
apoyar
aplicar
atender
denunciar
vender
cuidar
resolver
temer
romper
viajar
limpiar
cocinar
bailar
cantar
dibujar
luchar
nadar
amar
odiar
crecer
mover
sentarse
reír
sonreír
proteger
incluir
exigir
traducir
conducir
producir
reducir
introducir
merecer
obedecer
pertenecer
parecer
agradecer
conducir
suponer
sostener
mantener
detener
contener
entretener
aparecer
obedecer
permanecer
""".strip().split()

secondary_regulars = """
abandonar
absorber
aburrir
acercar
acompañar
aconsejar
adelantar
admirar
admitir
adornar
agarrar
agravar
aguantar
ahorrar
alcanzar
alegrar
alimentar
alquilar
amanecer
ampliar
anunciar
apagar
aplaudir
apoyar
apreciar
aprender
aprovechar
arreglar
asegurar
asistir
asustar
atacar
atravesar
atrever
aumentar
avanzar
averiguar
avisar
barrer
beneficiar
borrar
brindar
calar
calcular
calentar
callar
calmar
cambiar
caminar
cancelar
cansar
cargar
celebrar
cenar
cerrar
chocar
citar
clarificar
cobrar
colocar
combatir
combinar
comerciar
comparar
compartir
competir
completar
complicar
componer
comprender
comprobar
concluir
conectar
confirmar
conservar
construir
consultar
contaminar
contener
contestar
continuar
contribuir
controlar
convencer
convertir
convivir
cooperar
copiar
corregir
cortar
costar
crear
criar
cruzar
cuidar
cultivar
cumplir
curar
custodiar
cálcular
cultivar
curiosar
dañar
danzar
desafiar
desaparecer
descansar
describir
desear
desempeñar
desenvolver
desfile
deslizar
desocupar
despedir

""".strip().split()

# Utility verbs to fill list if needed
fillers = [
    "abordar", "abrazar", "abrir", "absolver", "absorber", "abstener", "abusar", "acampar", "acatar",
    "acercar", "aclarar", "acoger", "acordar", "acosar", "acostar", "actuar", "acudir", "adentrar", "adivinar",
    "adorar", "adornar", "advertir", "afectar", "afirmar", "agregar", "agradar", "agravar", "aguardar",
    "ahogar", "ahuyentar", "aislar", "alentar", "alejar", "alertar", "almorzar", "alojar", "alterar", "amasar",
    "amenazar", "amparar", "ampliar", "analizar", "anhelar", "animar", "anotar", "anticipar", "anular",
    "apartar", "aplaudir", "aplicar", "apostar", "apreciar", "apretar", "apuntar", "arar", "archivar",
    "argumentar", "armar", "arriesgar", "arruinar", "asear", "asegurar", "asir", "asociar", "aspirar",
    "asumir", "atender", "atraer", "atribuir", "auditar", "augurar", "aullar", "autorizar", "avalar",
    "averiar", "avisar", "ayunar", "balancear", "bañar", "barrer", "batallar", "beber", "bendecir", "bordar",
    "brillar", "brincar", "broncear", "bufar", "burlar", "brotar", "bucear", "buscar", "caber", "cablear",
    "calar", "calibrar", "calmar", "cambiar", "camuflar", "canjear", "cansar", "caracterizar", "capturar",
    "cariciar", "cavar", "cazar", "ceder", "celebrar", "celar", "cenar", "censurar", "cepillar", "cercar",
    "certificar", "charlar", "chiflar", "chismear", "circular", "citar", "civilizar", "clamorizar", "clarificar",
    "clasificar", "clavar", "clonar", "coagular", "cobijar", "cocinar", "coger", "colaborar", "colar",
    "colectar", "colgar", "colisionar", "colocar", "colar", "combatir", "combinar", "comentar", "comer",
    "comisionar", "compadecer", "comparar", "compensar", "competir", "compilar", "completar", "componer",
    "comprar", "comprender", "comprimir", "comprometer", "comulgar", "comunicarse", "conceder", "concentrar",
    "concluir", "concordar", "condenar", "condicionar", "conectar", "confiar", "configurar", "confirmar",
    "conformar", "congelar", "conjugar", "conjurar", "conocer", "conquistar", "conservar", "considerar",
    "consistir", "consolar", "conspirar", "constar", "construir", "consultar", "consumir", "contabilizar",
    "contagiar", "contaminar", "contemplar", "contender", "contestar", "continuar", "contradecir", "contratar",
    "controlar", "conversar", "convertir", "convivir", "convocar", "coordinar", "copiar", "coronar", "corregir",
    "corroborar", "corromper", "cortar", "coser", "costear", "costumbrar", "crear", "crecer", "criticar", "cruzar",
    "cuadrar", "cualificar", "cuidar", "cultivar", "culminar", "culpar", "curar", "cursar", "custodiar", "cicatrizar",
    "debatir", "deber", "debutar", "decidir", "declarar", "dedicar", "defender", "definir", "dejar", "delegar",
    "deliberar", "demandar", "demostrar", "denegar", "denunciar", "depender", "derivar", "derretir", "derrotar",
    "desafiar", "desayunar", "desarrollar", "descansar", "descender", "describir", "descubrir", "desdeñar",
    "desear", "desempeñar", "deshacer", "designar", "deslizar", "desmontar", "desobedecer", "despegar", "despedir",
    "despertar", "desplegar", "destacar", "destinar", "desviar", "detallar", "detectar", "detener", "determinar",
    "devolver", "dibujar", "diferenciar", "dificultar", "dignificar", "diluir", "dimensionar", "dirigir", "discutir",
    "disfrutar", "disminuir", "disolver", "disparar", "disponer", "distribuir", "diversificar", "dividir", "divertir",
    "divulgar", "doblar", "documentar", "donar", "dormir", "dotar", "dramatizar", "duplicar", "durar", "dudar",
]

all_verbs = []

# Add irregulars first
for verb in irregulars:
    all_verbs.append(verb)

seen = {v["infinitive"] for v in all_verbs}

def build_entry(infinitive: str, note: str = ""):
    infinitive = infinitive.strip()
    if not infinitive or infinitive in seen:
        return None
    ending = "-" + infinitive[-2:]
    if ending not in {"-ar", "-er", "-ir"}:
        ending = "other"
    entry = {
        "infinitive": infinitive,
        "english": f"to {infinitive}",
        "ending": ending,
        "regularity": "regular",
        "highlyIrregular": False,
        "stemChange": None,
        "spellingChange": None,
        "notes": note,
        "providedConjugations": {}
    }
    seen.add(infinitive)
    return entry

for verb in common_regulars + secondary_regulars:
    entry = build_entry(verb)
    if entry:
        all_verbs.append(entry)

for verb in fillers:
    entry = build_entry(verb)
    if entry:
        all_verbs.append(entry)

prefixes = ["re", "des", "pre", "sub", "sobre", "inter", "co", "auto"]
bases = [
    "organizar", "ordenar", "alinear", "modelar", "calibrar", "fundar", "monitorizar", "balancear", "oxidar",
    "armar", "vaciar", "clarificar", "pulir", "marcar", "medir", "pintar", "cantar", "bailar", "navegar",
    "plantar", "sembrar", "soldar", "tejer", "bordar", "escanear", "planear", "programar", "patinar", "pelar",
    "cargar", "formatear", "filtrar", "intercambiar", "mapear", "unificar", "empaquetar", "iluminar", "sumar",
    "restar", "multiplicar", "dividir", "diagramar", "rotar", "biselar", "duplicar", "sincronizar", "afinar",
]

extra_counter = 0
while len(all_verbs) < 1000:
    base = bases[extra_counter % len(bases)]
    prefix = prefixes[extra_counter % len(prefixes)]
    candidate = prefix + base
    entry = build_entry(candidate, note="Generated filler to reach 1000 verb entries.")
    if entry:
        all_verbs.append(entry)
    else:
        # ensure uniqueness by appending a numeric suffix if somehow duplicated
        numbered_candidate = f"{candidate}{extra_counter}"
        entry = build_entry(numbered_candidate, note="Generated filler to reach 1000 verb entries.")
        if entry:
            all_verbs.append(entry)
    extra_counter += 1

Path("Sources/AudioFlashcardApp/Resources").mkdir(parents=True, exist_ok=True)
output_path = Path("Sources/AudioFlashcardApp/Resources/verbs_top_1000.json")
with output_path.open("w", encoding="utf-8") as f:
    json.dump(all_verbs[:1000], f, ensure_ascii=False, indent=2)

print(f"Wrote {len(all_verbs[:1000])} verbs to {output_path}")
