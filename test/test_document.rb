require_relative 'test_case'

class RI::TestDocument < RI::TestCase
  def setup
    ResourceIndex.config(adapter: "amalgalite", username: "test", password: "test", database: "")
    ResourceIndex.db.create_table :obr_resource do
      primary_key :id
      String :name
      String :resource_id
      String :structure
      String :main_context
      String :url
      String :element_url
      String :description
      String :logo
      Integer :dictionary_id
      Integer :total_element
      Time :last_update_date
      Time :workflow_completed_date
    end
    ResourceIndex.db.run(RESOURCES_TEST_DATA)
    ResourceIndex.db.create_table :obr_ae_test_element do
      primary_key :id
      String :local_element_id
      Integer :dictionary_id
      String :ae_name
      String :ae_description
      String :ae_species
      String :ae_experiment_type
    end
    ResourceIndex.db.run(DOCUMENTS_TEST_DATA)
  end

  def teardown
    ResourceIndex.db[:obr_resource].delete
  end

  def test_documents
    assert_raises(ArgumentError) {RI::Document.all}
    res = RI::Resource.find("AE_test")
    docs = res.documents(chunk_size: 10)
    assert_equal Enumerator::Lazy, docs.class
    assert_equal 464, docs.to_a.length
    count = 0
    docs.each {|d| count += 1}
    assert_equal 464, count
    known_ids = ["E-MTAB-1371",  "E-MTAB-1289",  "E-MTAB-1147",  "E-MTAB-965",  "E-MEXP-3704",  "E-MEXP-3617",  "E-WMIT-1",  "E-TIGR-135",  "E-TIGR-120",  "E-TIGR-109",  "E-TIGR-108",  "E-TIGR-106",  "E-TIGR-105",  "E-TIGR-104",  "E-TIGR-103",  "E-TIGR-96",  "E-TABM-86",  "E-TABM-7",  "E-SNGR-9",  "E-SNGR-8",  "E-SNGR-1",  "E-SMDB-4088",  "E-SMDB-3690",  "E-SMDB-2855",  "E-SMDB-608",  "E-SMDB-605",  "E-SMDB-25",  "E-SMDB-23",  "E-SMDB-21",  "E-SMDB-18",  "E-SMDB-15",  "E-SMDB-8",  "E-SMDB-6",  "E-RZPD-10",  "E-RZPD-7",  "E-RZPD-5",  "E-RZPD-4",  "E-RZPD-3",  "E-RZPD-2",  "E-RZPD-1",  "E-MTAB-1328",  "E-MIMR-42",  "E-MIMR-17",  "E-MIMR-7",  "E-MEXP-3675",  "E-MEXP-46",  "E-MEXP-34",  "E-MEXP-32",  "E-MEXP-5",  "E-MAXD-11",  "E-MAXD-8",  "E-LGCL-3",  "E-LGCL-2",  "E-IPKG-1",  "E-GEOD-13561",  "E-FPMI-1",  "E-ERAD-145",  "E-ERAD-144",  "E-DKFZ-1",  "E-BAIR-12",  "E-BAIR-11",  "E-BAIR-10",  "E-BAIR-9",  "E-BAIR-8",  "E-BAIR-1",  "E-BASE-1",  "E-ERAD-92",  "E-ERAD-69",  "E-ERAD-67",  "E-ERAD-56",  "E-MEXP-3723",  "E-MTAB-964",  "E-ERAD-68",  "E-MTAB-1445",  "E-MTAB-1410",  "E-MTAB-1358",  "E-MTAB-1308",  "E-MEXP-3775",  "E-MEXP-3522",  "E-MEXP-3720",  "E-MEXP-3350",  "E-GEOD-43669",  "E-GEOD-43653",  "E-GEOD-43651",  "E-GEOD-42913",  "E-GEOD-33273",  "E-GEOD-33272",  "E-GEOD-33271",  "E-GEOD-22087",  "E-GEOD-16035",  "E-MTAB-1429",  "E-GEOD-43645",  "E-GEOD-43512",  "E-GEOD-43433",  "E-GEOD-43188",  "E-GEOD-43179",  "E-GEOD-43178",  "E-GEOD-43177",  "E-GEOD-42867",  "E-GEOD-42844",  "E-GEOD-42800",  "E-GEOD-42799",  "E-GEOD-42798",  "E-GEOD-42698",  "E-GEOD-41688",  "E-GEOD-39998",  "E-GEOD-39918",  "E-GEOD-39334",  "E-GEOD-39058",  "E-GEOD-39057",  "E-GEOD-39055",  "E-GEOD-39052",  "E-GEOD-39040",  "E-GEOD-38993",  "E-GEOD-38746",  "E-GEOD-38651",  "E-GEOD-37714",  "E-GEOD-37713",  "E-GEOD-37712",  "E-GEOD-37040",  "E-GEOD-35710",  "E-GEOD-34845",  "E-GEOD-34844",  "E-GEOD-32020",  "E-GEOD-27916",  "E-GEOD-27657",  "E-GEOD-26586",  "E-GEOD-17989",  "E-GEOD-15654",  "E-ERAD-139",  "E-ERAD-61",  "E-ERAD-60",  "E-GEOD-43363",  "E-GEOD-42861",  "E-GEOD-39521",  "E-GEOD-35493",  "E-GEOD-32584",  "E-GEOD-43582",  "E-GEOD-42454",  "E-GEOD-42447",  "E-GEOD-42443",  "E-GEOD-37842",  "E-GEOD-43639",  "E-GEOD-43636",  "E-GEOD-43635",  "E-GEOD-43634",  "E-GEOD-43630",  "E-GEOD-43621",  "E-GEOD-43618",  "E-GEOD-43611",  "E-GEOD-43607",  "E-GEOD-43593",  "E-GEOD-43386",  "E-GEOD-43302",  "E-GEOD-34213",  "E-GEOD-43608",  "E-GEOD-43603",  "E-GEOD-43595",  "E-GEOD-43588",  "E-GEOD-43585",  "E-GEOD-43581",  "E-GEOD-43570",  "E-GEOD-43569",  "E-GEOD-43568",  "E-GEOD-43567",  "E-GEOD-43566",  "E-GEOD-43563",  "E-GEOD-42670",  "E-GEOD-42669",  "E-GEOD-42616",  "E-GEOD-42580",  "E-GEOD-42577",  "E-GEOD-42261",  "E-GEOD-42260",  "E-GEOD-42259",  "E-GEOD-41561",  "E-GEOD-41341",  "E-GEOD-41336",  "E-GEOD-41331",  "E-GEOD-38994",  "E-GEOD-37386",  "E-GEOD-32868",  "E-GEOD-32617",  "E-GEOD-31466",  "E-GEOD-23771",  "E-GEOD-22049",  "E-MTAB-1356",  "E-MTAB-1245",  "E-MTAB-1214",  "E-MTAB-1090",  "E-MTAB-1049",  "E-MTAB-1044",  "E-MTAB-960",  "E-MTAB-840",  "E-MTAB-696",  "E-MEXP-3768",  "E-MEXP-3662",  "E-MEXP-3657",  "E-MEXP-3651",  "E-MEXP-3596",  "E-MEXP-3542",  "E-MEXP-3507",  "E-MEXP-3490",  "E-GEOD-43598",  "E-GEOD-43584",  "E-GEOD-43564",  "E-GEOD-43559",  "E-GEOD-43548",  "E-GEOD-43547",  "E-GEOD-43535",  "E-GEOD-43534",  "E-GEOD-43524",  "E-GEOD-43509",  "E-GEOD-43496",  "E-GEOD-43425",  "E-GEOD-42701",  "E-GEOD-42576",  "E-GEOD-42575",  "E-GEOD-42574",  "E-GEOD-41677",  "E-GEOD-40739",  "E-GEOD-38848",  "E-GEOD-38379",  "E-GEOD-38377",  "E-GEOD-38371",  "E-GEOD-34132",  "E-GEOD-33074",  "E-GEOD-33073",  "E-GEOD-31073",  "E-GEOD-29767",  "E-GEOD-26751",  "E-GEOD-26750",  "E-GEOD-26749",  "E-MTAB-1121",  "E-MEXP-3807",  "E-MEXP-3679",  "E-MEXP-3678",  "E-MEXP-3518",  "E-MEXP-3071",  "E-GEOD-43553",  "E-GEOD-43517",  "E-GEOD-43516",  "E-GEOD-43508",  "E-GEOD-43506",  "E-GEOD-43503",  "E-GEOD-43498",  "E-GEOD-43497",  "E-GEOD-40126",  "E-GEOD-39630",  "E-GEOD-39617",  "E-GEOD-38230",  "E-GEOD-38229",  "E-GEOD-38228",  "E-GEOD-38045",  "E-MTAB-1186",  "E-MTAB-1093",  "E-MTAB-951",  "E-MEXP-3763",  "E-GEOD-43502",  "E-GEOD-43494",  "E-GEOD-43493",  "E-GEOD-43492",  "E-GEOD-43487",  "E-GEOD-43486",  "E-GEOD-43485",  "E-GEOD-43484",  "E-GEOD-43482",  "E-GEOD-43481",  "E-GEOD-43480",  "E-GEOD-43479",  "E-GEOD-43476",  "E-GEOD-43472",  "E-GEOD-43471",  "E-GEOD-43469",  "E-GEOD-43468",  "E-GEOD-43464",  "E-GEOD-43447",  "E-GEOD-43381",  "E-GEOD-43249",  "E-GEOD-43220",  "E-GEOD-42936",  "E-GEOD-42883",  "E-GEOD-42655",  "E-GEOD-42551",  "E-GEOD-42462",  "E-GEOD-40147",  "E-GEOD-40116",  "E-GEOD-39842",  "E-GEOD-38897",  "E-GEOD-38200",  "E-GEOD-38169",  "E-GEOD-38110",  "E-GEOD-27237",  "E-GEOD-42912",  "E-GEOD-42880",  "E-GEOD-42865",  "E-GEOD-41054",  "E-GEOD-40841",  "E-GEOD-39509",  "E-GEOD-39150",  "E-GEOD-38463",  "E-GEOD-35896",  "E-GEOD-35288",  "E-GEOD-23435",  "E-GEOD-32934",  "E-GEOD-43466",  "E-GEOD-43465",  "E-GEOD-43452",  "E-GEOD-43446",  "E-GEOD-43445",  "E-GEOD-43441",  "E-GEOD-42544",  "E-GEOD-41193",  "E-GEOD-41192",  "E-GEOD-41188",  "E-GEOD-14995",  "E-MTAB-981",  "E-GEOD-43415",  "E-GEOD-43413",  "E-GEOD-43407",  "E-GEOD-43403",  "E-GEOD-43291",  "E-GEOD-41986",  "E-GEOD-41383",  "E-GEOD-39901",  "E-GEOD-39273",  "E-GEOD-36311",  "E-GEOD-35309",  "E-GEOD-34994",  "E-GEOD-34643",  "E-GEOD-33341",  "E-GEOD-32175",  "E-GEOD-31030",  "E-GEOD-29448",  "E-GEOD-29365",  "E-GEOD-28731",  "E-GEOD-27302",  "E-GEOD-25609",  "E-GEOD-13214",  "E-MTAB-1436",  "E-MTAB-1231",  "E-MTAB-1217",  "E-MTAB-744",  "E-MTAB-743",  "E-MTAB-742",  "E-MEXP-3800",  "E-GEOD-43410",  "E-GEOD-43377",  "E-GEOD-43370",  "E-GEOD-43193",  "E-GEOD-42882",  "E-GEOD-41004",  "E-GEOD-40722",  "E-GEOD-40583",  "E-GEOD-40366",  "E-GEOD-40110",  "E-GEOD-40031",  "E-GEOD-39976",  "E-GEOD-39889",  "E-GEOD-39793",  "E-GEOD-38972",  "E-GEOD-38168",  "E-GEOD-36893",  "E-GEOD-36808",  "E-GEOD-35843",  "E-GEOD-35179",  "E-GEOD-35051",  "E-GEOD-35040",  "E-GEOD-35039",  "E-GEOD-35000",  "E-GEOD-34585",  "E-GEOD-33958",  "E-GEOD-33957",  "E-GEOD-26600",  "E-MTAB-1428",  "E-MTAB-1425",  "E-MEXP-3509",  "E-GEOD-43373",  "E-GEOD-43351",  "E-GEOD-43339",  "E-GEOD-43333",  "E-GEOD-42952",  "E-GEOD-42890",  "E-GEOD-42140",  "E-GEOD-40205",  "E-GEOD-39270",  "E-GEOD-37653",  "E-GEOD-36696",  "E-GEOD-34977",  "E-GEOD-34729",  "E-GEOD-33217",  "E-GEOD-33106",  "E-ERAD-129",  "E-MTAB-1433",  "E-MTAB-1432",  "E-MTAB-1059",  "E-MTAB-388",  "E-MEXP-3799",  "E-MEXP-3752",  "E-MEXP-3714",  "E-GEOD-43325",  "E-GEOD-43324",  "E-GEOD-43315",  "E-GEOD-43310",  "E-GEOD-41777",  "E-GEOD-41776",  "E-GEOD-41616",  "E-GEOD-41257",  "E-GEOD-39301",  "E-GEOD-39174",  "E-GEOD-39104",  "E-GEOD-39103",  "E-GEOD-38761",  "E-GEOD-38760",  "E-GEOD-38759",  "E-GEOD-38758",  "E-GEOD-38757",  "E-GEOD-38756",  "E-GEOD-37136",  "E-GEOD-31189",  "E-GEOD-28471",  "E-ERAD-130",  "E-GEOD-43307",  "E-GEOD-43282",  "E-GEOD-43208",  "E-GEOD-41937",  "E-GEOD-40767",  "E-GEOD-40766",  "E-GEOD-40762",  "E-GEOD-38995",  "E-GEOD-38573",  "E-GEOD-38261",  "E-GEOD-38212",  "E-GEOD-38211",  "E-GEOD-38210",  "E-GEOD-34119",  "E-ERAD-59",  "E-ERAD-52",  "E-ERAD-48",  "E-GEOD-41691",  "E-GEOD-41232",  "E-GEOD-39323",  "E-GEOD-39321",  "E-GEOD-39159",  "E-GEOD-39154",  "E-GEOD-34923",  "E-GEOD-32909",  "E-GEOD-32422",  "E-MTAB-930",  "E-GEOD-43301",  "E-GEOD-43300",  "E-GEOD-43290",  "E-GEOD-43287",  "E-GEOD-43204",  "E-GEOD-43203",  "E-GEOD-42908",  "E-GEOD-36596",  "E-GEOD-33116",  "E-MTAB-1435",  "E-MTAB-1404",  "E-MTAB-1402",  "E-GEOD-43272",  "E-GEOD-43271",  "E-GEOD-43255"]
    ids = docs.map {|d| d.document_id}.force
    assert_equal known_ids.sort, ids.sort
  end

  def test_document_indexable
    res = RI::Resource.find("AE_test")
    doc = res.documents.to_a.first
    hash = doc.indexable_hash
    keys = [:ae_name, :ae_description, :ae_species, :ae_experiment_type, :id]
    assert_equal keys.sort, hash.keys.sort
    assert_equal "CLIP-Seq of H. sapiens HeLa cells to investigate transcriptome-wide mapping of hnRNP C and U2AF65", hash[:ae_name]
  end
end