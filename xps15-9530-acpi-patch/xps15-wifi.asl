/*
 * A) CNVW.IFUN calls ^^RP28.PXSX.WIST() unguarded, but RP25-28 are never
 *    created on this CNVi SKU, so every Wi-Fi _DSM aborts:
 *      ACPI BIOS Error (bug): Could not resolve symbol [^^RP28.PXSX.WIST]
 *    Stubbing WIST and defining the four dangling CNVW Names resolves it.
 *
 * B) Dell sets UHBS bit0=1 to disable 6 GHz; clearing it unlocks 6E. Rides
 *    the same _DSM, so (A) is a prerequisite.
 */
DefinitionBlock ("", "SSDT", 2, "XPS15", "XPSWIFI", 0x00000001)
{
    External (\UHBS, IntObj)
    External (\_SB.PC00, DeviceObj)
    External (\_SB.PC00.CNVW, DeviceObj)

    Scope (\_SB.PC00)
    {
        Device (RP28)
        {
            Name (_ADR, 0x001D0003)
            Method (_STA, 0, NotSerialized) { Return (Zero) }   // hidden from enumeration
            Device (PXSX)
            {
                Name (_ADR, Zero)
                Method (WIST, 0, Serialized) { Return (Zero) }   // matches RP01-24 on this SKU
            }
        }
    }

    Scope (\_SB.PC00.CNVW)
    {
        Name (RSTY, Zero)
        Name (FLRC, Zero)
        Name (BOFC, Zero)
        Name (DPRS, Zero)
        Method (_INI, 0, NotSerialized)
        {
            UHBS = Zero                       // 6 GHz unlock, set once before iwlwifi loads
        }
    }
}
