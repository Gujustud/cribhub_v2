package com.brother.ptouch.sdk.printdemo.model

import com.brother.sdk.lmprinter.PrinterModel
import junit.framework.TestCase

class PrinterInfoKtTest : TestCase() {

    fun testGuessPrinterModels() {
        guessPrinterModels("QL-820NWB").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.QL_820NWB))
        }
        guessPrinterModels("PT-D410").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.PT_D410))
        }
        guessPrinterModels("TD-2125N").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.TD_2125N))
        }
        guessPrinterModels("TD-2125NWB").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.TD_2125NWB))
        }
        guessPrinterModels("TD-2125N_2125").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.TD_2125N))
        }
        guessPrinterModels("TD-2125NWB_2125").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.TD_2125NWB))
        }
        guessPrinterModels("QL-820NWB6543").let {
            assertEquals(it.size,1)
            assert(it.contains(PrinterModel.QL_820NWB))
        }
        guessPrinterModels("TD-2350D_203").let {
            assertEquals(it.size,2)
            assert(it.contains(PrinterModel.TD_2350D_203))
            assert(it.contains(PrinterModel.TD_2350D_300))
        }
        guessPrinterModels("TD-2350D").let {
            assertEquals(it.size,2)
            assert(it.contains(PrinterModel.TD_2350D_203))
            assert(it.contains(PrinterModel.TD_2350D_300))
        }
        guessPrinterModels("TD-2350D_2030").let {
            assertEquals(it.size,2)
            assert(it.contains(PrinterModel.TD_2350D_203))
            assert(it.contains(PrinterModel.TD_2350D_300))
        }
        guessPrinterModels("TD-2350D203").let {
            assertEquals(it.size,2)
            assert(it.contains(PrinterModel.TD_2350D_203))
            assert(it.contains(PrinterModel.TD_2350D_300))
        }
        guessPrinterModels("TD-2350DFSA1234").let {
            assertEquals(it.size,6)
            assert(it.contains(PrinterModel.TD_2350DFSA_203))
            assert(it.contains(PrinterModel.TD_2350DFSA_300))
            assert(it.contains(PrinterModel.TD_2350D_203))
            assert(it.contains(PrinterModel.TD_2350D_300))
            assert(it.contains(PrinterModel.TD_2350DF_203))
            assert(it.contains(PrinterModel.TD_2350DF_300))
        }
    }
}
