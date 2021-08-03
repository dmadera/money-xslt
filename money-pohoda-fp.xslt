<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:decimal-format name="cs" decimal-separator="," grouping-separator=" " />
    <xsl:template match="S5Data/FakturaPrijataList">
        <dat:dataPack id="{generate-id(/)}" ico="46713301" application="Money S4" version = "2.0" note="Import faktur přijatých"        
                      xmlns:dat="http://www.stormware.cz/schema/version_2/data.xsd"        
                      xmlns:inv="http://www.stormware.cz/schema/version_2/invoice.xsd"        
                      xmlns:typ="http://www.stormware.cz/schema/version_2/type.xsd" >
            <xsl:for-each select="FakturaPrijata">
                <dat:dataPackItem version="2.0">
                    <xsl:attribute name="id"><xsl:value-of select="CisloDokladu"/></xsl:attribute>
                    <inv:invoice version="2.0">
                        <inv:invoiceHeader>
                            <xsl:choose>
                                <xsl:when test="ZapornyPohyb = 'False'">
                                    <inv:invoiceType>receivedInvoice</inv:invoiceType>
                                    <inv:text>Faktura za zboží</inv:text>
                                    <inv:originalDocument><xsl:value-of select="OdkazNaDoklad"/></inv:originalDocument>
                                </xsl:when>
                                <xsl:otherwise>
                                    <inv:invoiceType>receivedCorrectiveTax</inv:invoiceType>
                                    <inv:originalDocumentNumber><xsl:value-of select="PuvodniDoklad"/></inv:originalDocumentNumber>
                                    <inv:text>Dobropis k faktuře <xsl:value-of select="PuvodniDoklad"/></inv:text>
                                    <inv:originalDocument><xsl:value-of select="OdkazNaDoklad"/></inv:originalDocument>
                                </xsl:otherwise>        
                            </xsl:choose>
                            <inv:number>
                                <typ:numberRequested>
                                    <xsl:value-of select="CisloDokladu"/>
                                </typ:numberRequested>
                            </inv:number>
                            <inv:symVar><xsl:value-of select="VariabilniSymbol"/></inv:symVar>
                            <inv:date><xsl:value-of select="substring(DatumVystaveni, 1, 10)"/></inv:date>
                            <inv:dateKHDPH><xsl:value-of select="substring(DatumPlneni, 1, 10)"/></inv:dateKHDPH>
                            <inv:dateDue><xsl:value-of select="substring(DatumSplatnosti, 1, 10)"/></inv:dateDue>
                            <inv:accounting>
                                <typ:ids>Zboží</typ:ids>
                            </inv:accounting>
                            <inv:classificationVAT>
                                <typ:ids>PD</typ:ids>
                            </inv:classificationVAT>
                            <inv:partnerIdentity>
                                <typ:address>
                                    <typ:name><xsl:value-of select="Adresa/KontaktniOsobaNazev"/></typ:name>
                                    <typ:company><xsl:value-of select="Adresa/Nazev"/></typ:company>
                                    <typ:city><xsl:value-of select="Adresa/Misto"/></typ:city>
                                    <typ:street><xsl:value-of select="Adresa/Ulice"/></typ:street>
                                    <typ:zip><xsl:value-of select="Adresa/PSC"/></typ:zip>
                                    <typ:ico><xsl:value-of select="IC"/></typ:ico>
                                    <typ:dic><xsl:value-of select="DIC"/></typ:dic>
                                    <typ:VATPayerType>
                                        <xsl:choose>
                                            <xsl:when test="Adresa/Firma/PlatceDPH = 'True'">payer</xsl:when>
                                            <xsl:otherwise>non-payer</xsl:otherwise>
                                        </xsl:choose>
                                    </typ:VATPayerType>
                                </typ:address>
                            </inv:partnerIdentity>
                            <inv:paymentType>
                                <typ:ids>
                                    <xsl:choose>
                                        <xsl:when test="ZpusobPlatby/Kod = 'Z'">zálohou</xsl:when>
                                        <xsl:otherwise>Příkazem</xsl:otherwise>
                                    </xsl:choose>
                                </typ:ids>
                            </inv:paymentType>
                            <inv:account>
                                <typ:accountNo><xsl:value-of select="BankovniSpojeni/CisloUctu"/></typ:accountNo>
                                <typ:bankCode><xsl:value-of select="BankovniSpojeni/Banka/CiselnyKod"/></typ:bankCode>
                            </inv:account>                      
                        </inv:invoiceHeader>
                        <inv:invoiceSummary>
                            <inv:homeCurrency>
                                <xsl:choose>
                                    <xsl:when test="ZapornyPohyb = 'False'">
                                        <typ:priceNone><xsl:value-of select="DPH0/Zaklad" /></typ:priceNone>
                                        <typ:priceLow><xsl:value-of select="DPH1/Zaklad" /></typ:priceLow>
                                        <typ:priceLowVAT><xsl:value-of select="DPH1/Dan" /></typ:priceLowVAT>
                                        <typ:priceLowSum><xsl:value-of select="DPH1/Celkem" /></typ:priceLowSum>
                                        <typ:priceHigh><xsl:value-of select="DPH2/Zaklad" /></typ:priceHigh>
                                        <typ:priceHighVAT><xsl:value-of select="DPH2/Dan" /></typ:priceHighVAT>
                                        <typ:priceHighSum><xsl:value-of select="DPH2/Celkem" /></typ:priceHighSum>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <typ:priceNone><xsl:value-of select="DPH0/Zaklad * -1" /></typ:priceNone>
                                        <typ:priceLow><xsl:value-of select="DPH1/Zaklad * -1" /></typ:priceLow>
                                        <typ:priceLowVAT><xsl:value-of select="DPH1/Dan * -1" /></typ:priceLowVAT>
                                        <typ:priceLowSum><xsl:value-of select="DPH1/Celkem * -1" /></typ:priceLowSum>
                                        <typ:priceHigh><xsl:value-of select="DPH2/Zaklad * -1" /></typ:priceHigh>
                                        <typ:priceHighVAT><xsl:value-of select="DPH2/Dan * -1" /></typ:priceHighVAT>
                                        <typ:priceHighSum><xsl:value-of select="DPH2/Celkem * -1" /></typ:priceHighSum>
                                    </xsl:otherwise>  
                                </xsl:choose>  
                                <typ:round>
                                    <typ:priceRound><xsl:value-of select="Korekce0/Celkem" /></typ:priceRound>
                                </typ:round>
                            </inv:homeCurrency>
                        </inv:invoiceSummary>
                    </inv:invoice>
                </dat:dataPackItem>
            </xsl:for-each>
        </dat:dataPack>
    </xsl:template>
</xsl:stylesheet>