module ResourceIndex; end
RI = ResourceIndex

require 'goo'
require 'ostruct'
require 'sequel'
require 'typhoeus/adapters/faraday'
require 'ncbo_resource_index/version'
require 'ncbo_resource_index/resource'
require 'ncbo_resource_index/class'
require 'ncbo_resource_index/enumerable'
require 'ncbo_resource_index/document'
require 'ncbo_resource_index/multi_search'
require 'ncbo_resource_index/population/population'
require 'ncbo_resource_index/population/document'

module ResourceIndex
  HASH_SEED = 112233
  VIRT_MAP = {1000 => "MA", 1001 => "GRO-CPGA", 1005 => "BTO", 1006 => "CL", 1007 => "CHEBI", 1008 => "DDANAT", 1009 => "DOID", 1010 => "EMAP", 1011 => "IEV", 1012 => "ECO", 1013 => "EVOC", 1014 => "FIX", 1015 => "FB-BT", 1016 => "FB-DV", 1017 => "FB-CV", 1019 => "FAO", 1020 => "HC", 1021 => "EHDAA", 1022 => "EHDA", 1023 => "FBbi", 1024 => "LHN", 1025 => "MP", 1026 => "MAO", 1027 => "MFO", 1029 => "IMR", 1030 => "TGMA", 1031 => "MPATH", 1032 => "NCIT", 1033 => "NMR", 1035 => "PW", 1036 => "PECO", 1037 => "PTO", 1038 => "PSDS", 1039 => "PROPREO", 1040 => "PPIO", 1041 => "PSIMOD", 1042 => "OBOREL", 1043 => "REX", 1044 => "SEP", 1046 => "SBO", 1047 => "GRO-CPD", 1048 => "WB-BT", 1049 => "WB-LS", 1050 => "ZEA", 1051 => "ZFA", 1052 => "PRO-ONT", 1053 => "FMA", 1054 => "AMINO-ACID", 1055 => "GALEN", 1057 => "RADLEX", 1058 => "SNPO", 1059 => "CPRO", 1060 => "CTONT", 1061 => "SOPHARM", 1062 => "PR", 1063 => "CARO", 1064 => "FB-SP", 1065 => "TADS", 1067 => "WB-PHENOTYPE", 1068 => "SAO", 1069 => "ENVO", 1070 => "GO", 1076 => "OCRE", 1077 => "MIRO", 1078 => "BSPO", 1081 => "TTO", 1082 => "GRO", 1083 => "NPO", 1084 => "NIFSTD", 1085 => "OGMD", 1086 => "OGDI", 1087 => "OGR", 1088 => "MHC", 1089 => "BIRNLEX", 1090 => "AAO", 1091 => "SPD", 1092 => "IDO", 1094 => "PTRANS", 1095 => "XAO", 1099 => "ATMO", 1100 => "OGI", 1101 => "ICD9CM", 1104 => "BRO", 1105 => "MS", 1107 => "PATO", 1108 => "PAE", 1109 => "SO", 1110 => "TAO", 1112 => "UO", 1114 => "BILA", 1115 => "YPO", 1116 => "BHO", 1122 => "SPO", 1123 => "OBI", 1125 => "HP", 1126 => "FHHO", 1128 => "CDAO", 1130 => "ACGT-MO", 1131 => "MO", 1132 => "NCBITAXON", 1134 => "BT", 1135 => "pseudo", 1136 => "EFO", 1141 => "OPB", 1142 => "EP", 1144 => "DC-CL", 1146 => "ECG", 1148 => "BP-METADATA", 1149 => "DERMLEX", 1150 => "RS", 1152 => "MAT", 1158 => "CBO", 1172 => "VO", 1183 => "LIPRO", 1190 => "OPL", 1192 => "CPTAC", 1222 => "APO", 1224 => "SYMP", 1237 => "SITBAC", 1247 => "GEOSPECIES", 1249 => "SBRO", 1257 => "MEGO", 1290 => "ABA-AMB", 1304 => "BCGO", 1311 => "IDOMAL", 1314 => "CLO", 1321 => "NEMO", 1328 => "HOM", 1332 => "BFO", 1335 => "PEO", 1341 => "COSTART", 1343 => "HL7", 1344 => "ICPC", 1347 => "MEDLINEPLUS", 1348 => "OMIM", 1349 => "PDQ", 1350 => "LOINC", 1351 => "MESH", 1352 => "NDFRT", 1353 => "SNOMEDCT", 1354 => "WHO-ART", 1362 => "HAO", 1369 => "PHYFIELD", 1370 => "ATO", 1381 => "NIFDYS", 1393 => "IAO", 1394 => "SSO", 1397 => "GAZ", 1398 => "LDA", 1401 => "ICNP", 1402 => "NIFCELL", 1404 => "UBERON", 1407 => "TEDDY", 1410 => "KISAO", 1411 => "ICF", 1413 => "SWO", 1414 => "OGMS", 1415 => "CTCAE", 1417 => "FLU", 1418 => "TOK", 1419 => "TAXRANK", 1422 => "MEDDRA", 1423 => "RXNORM", 1424 => "NDDF", 1425 => "ICD10PCS", 1426 => "MDDB", 1427 => "RCD", 1428 => "NIC", 1429 => "ICPC2P", 1430 => "AI-RHEUM", 1438 => "MCBCC", 1439 => "GFO", 1440 => "GFO-BIO", 1444 => "CHEMINF", 1461 => "TMO", 1484 => "ICECI", 1487 => "ICD11-BODYSYSTEM", 1488 => "JERM", 1489 => "OAE", 1490 => "PLATSTG", 1491 => "IMGT-ONTOLOGY", 1494 => "TMA", 1497 => "PMA", 1498 => "EDAM", 1500 => "RNAO", 1501 => "NEOMARK3", 1504 => "CPT", 1505 => "OMIT", 1506 => "GO-EXT", 1507 => "CCO", 1509 => "ICPS", 1510 => "CPTH", 1515 => "INO", 1516 => "ICD10", 1517 => "EHDAA2", 1520 => "LSM", 1521 => "NEUMORE", 1522 => "BP", 1523 => "OBOE-SBC", 1526 => "CRISP", 1527 => "VANDF", 1528 => "HUGO", 1529 => "HCPCS", 1530 => "ADW", 1532 => "SIO", 1533 => "BAO", 1537 => "IDOBRU", 1538 => "ROLEO", 1539 => "NIGO", 1540 => "DDI", 1541 => "MCCL", 1544 => "CO", 1545 => "CO-WHEAT", 1550 => "PHARE", 1552 => "REPO", 1553 => "ICD10CM", 1555 => "VSAO", 1560 => "COGPO", 1565 => "OMRSE", 1567 => "PVONTO", 1568 => "AEO", 1569 => "HPIO", 1570 => "TM-CONST", 1571 => "TM-OTHER-FACTORS", 1572 => "TM-SIGNS-AND-SYMPTS", 1573 => "TM-MER", 1574 => "VHOG", 1575 => "EXO", 1576 => "FDA-MEDDEVICE", 1578 => "ELIXHAUSER", 1580 => "AERO", 1581 => "HLTHINDCTRS", 1582 => "CAO", 1583 => "CMO", 1584 => "MMO", 1585 => "XCO", 1586 => "OntoOrpha", 1587 => "PO", 1588 => "ONTODT", 1613 => "BDO", 1614 => "IXNO", 1615 => "CHEMBIO", 1616 => "PHYLONT", 1621 => "NBO", 1626 => "EMO", 1627 => "HOMERUN", 1630 => "UCSFEPIC", 1632 => "WSIO", 1633 => "COGAT", 1638 => "ONTODM-CORE", 1639 => "EPILONT", 1640 => "PEDTERM", 1649 => "OSHPD", 1650 => "UNITSONT", 1651 => "SDO", 1655 => "PHARMGKB", 1656 => "PHENOMEBLAST", 1659 => "VT", 1661 => "UCSFXPLANT", 1665 => "SHR", 1666 => "MFOEM", 1670 => "ICDO3", 1671 => "QIBO", 1672 => "DIKB", 1676 => "RCTONT", 1686 => "NEOMARK4", 1689 => "FYPO", 1694 => "CPT-KM", 1696 => "SYN", 1697 => "UCSFORTHO", 1699 => "VIVO", 3000 => "MIXSCV", 3002 => "MF", 3003 => "CNO", 3004 => "NATPRO", 3006 => "OOEVV", 3007 => "UCSFICU", 3008 => "CARELEX", 3009 => "MEO", 3012 => "NONRCTO", 3013 => "DIAGONT", 3015 => "PMR", 3016 => "ERO", 3017 => "GCC", 3019 => "RH-MESH", 3020 => "CPO", 3021 => "ATC", 3022 => "BIOMODELS", 3025 => "CTX", 3028 => "SOY", 3029 => "SPTO", 3030 => "CANCO", 3031 => "QUDT", 3032 => "EPICMEDS", 3038 => "HOM-TEST", 3042 => "TEO", 3043 => "MEDABBS", 3045 => "ICD9CM-KM", 3046 => "MDCDRG", 3047 => "DEMOGRAPH", 3058 => "DWC", 3062 => "I2B2-PATVISDIM", 3077 => "ONTODM-KDD", 3078 => "PHENX", 3090 => "ONTOMA", 3092 => "CLINIC", 3094 => "DWC-TEST", 3104 => "USSOC", 3108 => "CCONT", 3114 => "RPO", 3119 => "OBIWS", 3120 => "PCO", 3124 => "VSO", 3126 => "NIFSUBCELL", 3127 => "IMMDIS", 3129 => "CONSENT-ONT", 3131 => "PROVO", 3136 => "NHDS", 3137 => "ONSTR", 3139 => "MIRNAO", 3146 => "CMS", 3147 => "CLIN-EVAL", 3150 => "BRIDG", 3151 => "GEXO", 3152 => "REXO", 3153 => "NTDO", 3155 => "ONTOKBCF", 3157 => "GENETRIAL", 3158 => "SWEET", 3159 => "VARIO", 3162 => "RETO", 3167 => "GLOB", 3169 => "GLYCO", 3174 => "IDODEN", 3176 => "XEO", 3178 => "CANONT", 3179 => "GENE-CDS", 3180 => "MEDO", 3181 => "ONTOPNEUMO", 3183 => "IFAR", 3184 => "ZIP3", 3185 => "GPI", 3186 => "I2B2-LOINC", 3189 => "TOP-MENELAS", 3190 => "PATHLEX", 3191 => "MPO", 3192 => "MCCV", 3194 => "PHENOSCAPE-EXT", 3195 => "ICD09", 3197 => "HIMC-CPT", 3198 => "SEMPHYSKB-HUMAN", 3199 => "UCSFICD910CM", 3200 => "ZIP5", 3201 => "BCO", 3203 => "HINO", 3204 => "PORO", 3205 => "ICD0", 3206 => "HCPCS-HIMC", 3207 => "ATOL", 3208 => "IDQA", 3209 => "OPE", 3210 => "TRAK", 3211 => "TEST-PROD", 3212 => "GLYCOPROT", 3214 => "OGSF", 3215 => "MIXS", 3216 => "BAO-GPCR", 3217 => "CABRO", 3218 => "TRON", 3219 => "MSTDE", 3220 => "MSTDE-FRE", 3221 => "DERMO", 3222 => "RSA", 3223 => "GCO", 3224 => "UCSFI9I10CMPCS", 3226 => "SBOL", 3227 => "OVAE", 3228 => "ELIG", 3230 => "EPSO", 3231 => "GLYCANONT", 3232 => "SNMI", 3233 => "CHD", 3234 => "BOF", 3236 => "VTO", 3237 => "VBCV", 3238 => "PDO", 3239 => "CSSO", 3240 => "RNPRIO", 3241 => "UDEF", 3242 => "NHSQI", 3243 => "NHSQI2009", 3244 => "SEDI", 3245 => "SuicidO", 3246 => "ONL-MSA", 3247 => "EDDA", 3249 => "ONL-DP", 3250 => "ONL-MR-DA", 3251 => "ADO", 3252 => "SSE", 3253 => "OntoVIP", 3255 => "CHMO", 3258 => "OBR-Scolio", 3259 => "InterNano", 3261 => "STNFRDRXDEMO", 3262 => "BCTEO", 3263 => "OntoBioUSP", 3264 => "WH", 3265 => "BNO", 3266 => "OBI_BCGO", 3267 => "DCO", 3268 => "ERNO", 3269 => "BICSO", 3270 => "suicideo", 3271 => "BSAO", 3272 => "CARD", 3273 => "HRDO", 3274 => "MSV"}

  REQUIRED_OPTS = [:username, :password]
  def self.config(opts = {})
    raise ArgumentError, "You need to pass db_opts for #{self.class.name}" unless opts && opts.is_a?(Hash)
    missing_opts = REQUIRED_OPTS - opts.keys
    raise ArgumentError, "Missing #{missing_opts.join(', ')} from db options" unless missing_opts.empty? || opts[:sqlite]
    opts[:host]           ||= "localhost"
    opts[:port]           ||= 3306
    opts[:database]       ||= "resource_index"
    opts[:resource_store] ||= "resource_store"

    @opts = opts
    setup_sql_client

    # Elasticsearch
    es_hosts = opts[:es_hosts] || ["localhost"]
    es_port  = opts[:es_port] || 9200
    es_hosts = es_hosts.is_a?(Array) ? es_hosts : [es_hosts]
    @es      = ::Elasticsearch::Client.new(hosts: es_hosts, port: es_port, adapter: :typhoeus)
  end

  def self.es
    @es
  end

  def self.db
    @client
  end

  def self.settings
    @opts
  end

  def self.concept_docs(hashes, opts)
    MultiSearch.new.concept_docs(hashes, opts)
  end

  def self.concept_docs_page(hashes, opts)
    opts[:page] = true
    MultiSearch.new.concept_docs(hashes, opts)
  end

  private

  def self.setup_sql_client
    if RUBY_PLATFORM == "java"
      @opts[:adapter] = "jdbc"
      @opts[:uri] = "jdbc:mysql://#{@opts[:host]}:#{@opts[:port]}/#{@opts[:database]}?user=#{@opts[:username]}&password=#{@opts[:password]}"
    end
    @opts[:adapter] ||= "mysql2"
    @client = Sequel.connect(@opts)
  end
end