<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
<xsl:decimal-format name="cs" decimal-separator="," grouping-separator=" " />
<xsl:strip-space elements="*"/>
<xsl:template match="S5Data/NabidkaVydanaList/NabidkaVydana/Polozky">
<xsl:text>"Číslo položky","Kód","Název","Množství","Skladová cena","Marže","Poslední nákupní cena"</xsl:text><xsl:text>&#xD;</xsl:text>
<xsl:for-each select="PolozkaNabidkyVydane">
    <xsl:sort select="CisloPolozky"/>
    <xsl:text>"</xsl:text><xsl:value-of select="CisloPolozky"/>
    <xsl:text>","=""</xsl:text><xsl:value-of select="ObsahPolozky/Artikl/Kod"/>
    <xsl:text>""","</xsl:text><xsl:value-of select="Nazev"/>
    <xsl:text>","</xsl:text><xsl:value-of select="format-number(Mnozstvi, '#')"/>
    <xsl:text>","</xsl:text><xsl:value-of select="format-number(ObsahPolozky/Artikl/NakupniCena_UserData, '0,00', 'cs')"/>
    <xsl:text>","</xsl:text><xsl:value-of select="format-number(ObsahPolozky/Artikl/Marze_UserData, '0,00', 'cs')"/>
    <xsl:text>","</xsl:text><xsl:value-of select="format-number(ObsahPolozky/Artikl/PosledniCena, '0,00', 'cs')"/>
    <xsl:text>"&#xD;</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>