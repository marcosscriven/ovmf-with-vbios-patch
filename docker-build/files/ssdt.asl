DefinitionBlock ("Ssdt.aml", "SSDT", 1, "REDHAT", "OVMF2   ", 1) {
    /* copied from jscinoz */

    External(\_SB.PCI0.FWCF, DeviceObj)
    External(\_SB.PCI0.FWCF._CRS, BuffObj)

    Device (\_SB.PCI0.PEG0) {
        Name (_ADR, 0x00010000)
    }

    Device (\_SB.PCI0.PEG0.PEGP) {
        Name (_ADR, Zero)

        /* ROML and ROMB not necessary here */
        CreateByteField(\_SB.PCI0.FWCF._CRS, 0, ID)
        CreateWordField(\_SB.PCI0.FWCF._CRS, 2, BMIN)
        CreateWordField(\_SB.PCI0.FWCF._CRS, 4, BMAX)
        CreateByteField(\_SB.PCI0.FWCF._CRS, 7, LEN)

        // XXX: Unsure why, but these must be two separate regions, even though
        // FWD is entirely contained within FWC
        OperationRegion(FWC, SystemIO, BMIN, 2)
        OperationRegion(FWD, SystemIO, BMIN + 1, 1)
        Field(FWC, WordAcc, Lock, Preserve) {
            CTRL, 16
        }

        // Yes, DATA overlaps CTRL. This is not a mistake
        Field(FWD, ByteAcc, NoLock, Preserve) {
            DATA, 8
        }
    }

  /* define the ROM call */
  Scope (\_SB.PCI0.PEG0.PEGP)
    {
        Name (RVBS, 103936) // size of ROM in bytes

        External (\VBOR, OpRegionObj)
        Field (\VBOR, DWordAcc, Lock, Preserve)
        {
            VBS1,   262144, // length of segment in bits
            VBS2,   262144, 
            VBS3,   262144, 
            VBS4,   262144, 
            VBS5,   262144, 
            VBS6,   262144, 
            VBS7,   262144, 
            VBS8,   262144
        }

        Method (_ROM, 2, Serialized)  // _ROM: Read-Only Memory
        {
            Local0 = Arg0 // offset in bytes
            Local1 = Arg1 // length in bytes

            // create a buffer to store the result
            // initialize to empty buffer
            Name (VROM, Buffer (Local1)
            {
                 0x00
            })

            // length > 4k
            If (Local1 > 0x1000)
            {
                Local1 = 0x1000
            }

            // offset > size of ROM in bytes
            If (Local0 > RVBS)
            {
                Return (VROM) /* \_SB_.PCI0.PEG0.PEGP._ROM.VROM */
            }

            // end position
            Local2 = (Arg0 + Arg1)
            // end position > ROM size
            If (Local2 > RVBS)
            {
                // set length to image length - start offset
                Local1 = (RVBS - Local0)
            }

            // 0x8000: segment size in bytes
            // Local3: remainder, Local4: in which segment
            Divide (Local0, 0x8000, Local3, Local4)

            // set Local5 to the right segment
            If (Local4 == 0)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS1
            }
            ElseIf (Local4 == 1)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS2
            }
            ElseIf (Local4 == 2)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS3
            }
            ElseIf (Local4 == 3)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS4
            }
            ElseIf (Local4 == 4)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS5
            }
            ElseIf (Local4 == 5)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS6
            }
            ElseIf (Local4 == 6)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS7
            }
            ElseIf (Local4 == 7)
            {
                Local5 = \_SB.PCI0.PEG0.PEGP.VBS8
            }

            // extract from the segment starting from offset Local3 of size Local1
            // from Local 5 and store into VROM
            Mid (Local5, Local3, Local1, VROM)
            Return (VROM) /* \_SB_.PCI0.PEG0.PEGP._ROM.VROM */
        }
    }
}