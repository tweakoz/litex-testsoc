#!/usr/bin/env python3

import os, csv, json
from pathlib import Path

socdir = Path(os.environ["SOC_BUILD_DIR"])

################################################################################

csv_path = socdir/"mysoc_csr.csv"
json_path = socdir/"mysoc_csr.json"

################################################################################

with open(str(csv_path), newline='') as csvfile:
    csrs = dict()
    csr_table = csv.reader(csvfile, delimiter=',', quotechar="'")

    csrs["1.baseaddr"]=dict()
    csrs["2.regions"]=dict()
    csrs["3.byaddr"]=dict()
    csrs["4.registers"]=dict()
    for row in csr_table:
      if type(row)==list:
        if len(row)==5:
          grp = row[0]
          itm = row[1]
          adr = row[2]
          iln = "0x%08x"%int(row[3]) if len(row[3]) else ""
          acc = row[4]
          if grp=="constant":
              pass
          elif grp=="memory_region":
              csrs["2.regions"][adr] = { "item": itm, "length": iln }
          elif grp=="csr_base":
              csrs["1.baseaddr"][adr] = itm
          elif grp=="csr_register":
              csrs["4.registers"][itm] = { "addr": adr, "length": iln, "access": acc }
              csrs["3.byaddr"][adr] = { "item": itm, "length": iln, "access": acc}

    with open(str(json_path),"w") as f:
        r = json.dumps(csrs, sort_keys=True, indent=4, separators=(',', ': '))
        f.write(r)

################################################################################

def exec(s):
    os.system(s)

################################################################################

exec("dtc -O dtb -o ${PROJECT_ROOT}/tftp_root/arty/rv32.dtb ${PROJECT_ROOT}/buildroot-ext/board/testsoc/testsoc-arty.dts")
exec("dtc -O dts -o ${PROJECT_ROOT}/tftp_root/arty/rv32.dts ${PROJECT_ROOT}/tftp_root/arty/rv32.dtb")
exec("source-highlight --out-format=esc -o STDOUT -i ${PROJECT_ROOT}/tftp_root/arty/rv32.dts -s sh")
exec("source-highlight --out-format=esc -o STDOUT -i ${SOC_BUILD_DIR}/mysoc_csr.json -s json")
#exec("build.manifest.py")
