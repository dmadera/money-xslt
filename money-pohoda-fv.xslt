<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:decimal-format name="cs" decimal-separator="," grouping-separator=" " />
    <xsl:template match="S5Data/FakturaVydanaList">
        <dat:dataPack id="{generate-id(/)}" ico="46713301" application="Money S4" version = "2.0" note="Import faktur vydaných"        
                      xmlns:dat="http://www.stormware.cz/schema/version_2/data.xsd"        
                      xmlns:inv="http://www.stormware.cz/schema/version_2/invoice.xsd"        
                      xmlns:typ="http://www.stormware.cz/schema/version_2/type.xsd" >
            <xsl:for-each select="FakturaVydana">
                <dat:dataPackItem version="2.0">
                    <xsl:attribute name="id"><xsl:value-of select="CisloDokladu"/></xsl:attribute>
                    <inv:invoice version="2.0">
                        <inv:invoiceHeader>
                            <xsl:choose>
                                <xsl:when test="ZapornyPohyb = 'False'">
                                    <inv:invoiceType>issuedInvoice</inv:invoiceType>
                                    <inv:text>Fakturujeme Vám za zboží dle vaší objednávky</inv:text>
                                    <inv:originalDocument><xsl:value-of select="OdkazNaDoklad"/></inv:originalDocument>
                                </xsl:when>
                                <xsl:otherwise>
                                    <inv:invoiceType>issuedCorrectiveTax</inv:invoiceType>
                                    <inv:originalDocumentNumber>
                                        <xsl:value-of select="PuvodniDoklad"/>
                                    </inv:originalDocumentNumber>
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
                            <inv:dateTax><xsl:value-of select="substring(DatumPlneni, 1, 10)"/></inv:dateTax>
                            <inv:dateAccounting><xsl:value-of select="substring(DatumUcetnihoPripadu, 1, 10)"/></inv:dateAccounting>
                            <inv:dateDue><xsl:value-of select="substring(DatumSplatnosti, 1, 10)"/></inv:dateDue>
                            <xsl:if test="EvidovatNahradniPlneni = 'True'">
                                <inv:centre>
                                    <typ:ids>NP</typ:ids>
                                </inv:centre>
                            </xsl:if>
                            <xsl:if test="Cinnost/Kod = 'S_FA'">
                                <inv:activity>
                                    <typ:ids>SFa</typ:ids>
                                </inv:activity>
                            </xsl:if>
                            <inv:accounting>
                                <typ:ids>Zboží</typ:ids>
                            </inv:accounting>
                            <inv:classificationVAT>
                                <typ:ids>UD</typ:ids>
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
                                    <typ:email>
                                        <xsl:choose>
                                            <xsl:when test="Adresa/Firma/SeznamSpojeni//Spojeni[TypSpojeni/Kod = 'EmailNp'] != ''">
                                                <xsl:value-of select="Adresa/Firma/SeznamSpojeni//Spojeni[TypSpojeni/Kod = 'EmailNp']/SpojeniCislo" />
                                            </xsl:when>
                                            <xsl:when test="Adresa/Firma/SeznamSpojeni//Spojeni[TypSpojeni/Kod = 'EmailNp'] != ''">
                                                <xsl:value-of select="Adresa/Firma/SeznamSpojeni//Spojeni[TypSpojeni/Kod = 'EmailFa']/SpojeniCislo" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="Adresa/Firma/SeznamSpojeni//Spojeni[starts-with(TypSpojeni/Kod, 'Email')]/SpojeniCislo" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </typ:email>
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
                                        <xsl:when test="ZpusobPlatby/Kod = 'P'">Příkazem</xsl:when>
                                        <xsl:when test="ZpusobPlatby/Kod = 'H'">hotově</xsl:when>
                                        <xsl:when test="ZpusobPlatby/Kod = 'K'">plat.kartou</xsl:when>
                                        <xsl:when test="ZpusobPlatby/Kod = 'D'">dobírkou</xsl:when>
                                        <xsl:otherwise></xsl:otherwise>
                                    </xsl:choose>
                                </typ:ids>
                            </inv:paymentType>                            
                        </inv:invoiceHeader>
                        <inv:invoiceDetail>
                            <xsl:if test="DPH2/Zaklad > 0">
                                <inv:invoiceItem>
                                    <inv:text>Zboží v 21% sazbě DPH</inv:text>
                                    <inv:quantity>1</inv:quantity>
                                    <inv:rateVAT>high</inv:rateVAT>
                                    <inv:homeCurrency>
                                    <xsl:choose>
                                        <xsl:when test="ZapornyPohyb = 'False'">
                                            <typ:unitPrice><xsl:value-of select="DPH2/Zaklad" /></typ:unitPrice>
                                            <typ:price><xsl:value-of select="DPH2/Zaklad" /></typ:price>
                                            <typ:priceVAT><xsl:value-of select="DPH2/Dan" /></typ:priceVAT>
                                            <typ:priceSum><xsl:value-of select="DPH2/Celkem" /></typ:priceSum>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <typ:unitPrice><xsl:value-of select="DPH2/Zaklad * -1" /></typ:unitPrice>
                                            <typ:price><xsl:value-of select="DPH2/Zaklad * -1" /></typ:price>
                                            <typ:priceVAT><xsl:value-of select="DPH2/Dan * -1" /></typ:priceVAT>
                                            <typ:priceSum><xsl:value-of select="DPH2/Celkem * -1" /></typ:priceSum>
                                        </xsl:otherwise>        
                                    </xsl:choose>
                                    </inv:homeCurrency>
                                    <inv:classificationVAT>
                                        <typ:ids>UD</typ:ids>
                                    </inv:classificationVAT>
                                </inv:invoiceItem>
                            </xsl:if>
                            <xsl:if test="DPH1/Zaklad > 0">
                                <inv:invoiceItem>
                                    <inv:text>Zboží v 15% sazbě DPH</inv:text>
                                    <inv:quantity>1</inv:quantity>
                                    <inv:rateVAT>low</inv:rateVAT>
                                    <inv:homeCurrency>
                                    <xsl:choose>
                                        <xsl:when test="ZapornyPohyb = 'False'">
                                            <typ:unitPrice><xsl:value-of select="DPH1/Zaklad" /></typ:unitPrice>
                                            <typ:price><xsl:value-of select="DPH1/Zaklad" /></typ:price>
                                            <typ:priceVAT><xsl:value-of select="DPH1/Dan" /></typ:priceVAT>
                                            <typ:priceSum><xsl:value-of select="DPH1/Celkem" /></typ:priceSum>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <typ:unitPrice><xsl:value-of select="DPH1/Zaklad * -1" /></typ:unitPrice>
                                            <typ:price><xsl:value-of select="DPH1/Zaklad * -1" /></typ:price>
                                            <typ:priceVAT><xsl:value-of select="DPH1/Dan * -1" /></typ:priceVAT>
                                            <typ:priceSum><xsl:value-of select="DPH1/Celkem * -1" /></typ:priceSum>
                                        </xsl:otherwise>  
                                    </xsl:choose>    
                                    </inv:homeCurrency>
                                    <inv:classificationVAT>
                                        <typ:ids>UD</typ:ids>
                                    </inv:classificationVAT>
                                </inv:invoiceItem>
                            </xsl:if>
                            <xsl:for-each select="Polozky/PolozkaFakturyVydane[PreneseniDane_ID = '' and DPH/Sazba = 0]">
                                <inv:invoiceItem>
                                    <inv:text>DPH0: <xsl:value-of select="Nazev" /></inv:text>
                                    <inv:quantity>1</inv:quantity>
                                    <inv:rateVAT>none</inv:rateVAT>
                                    <inv:homeCurrency>
                                        <xsl:choose>
                                            <xsl:when test="(../../ZapornyPohyb = 'False' and Vratka = 'False') or (../../ZapornyPohyb = 'True' and Vratka = 'True') ">
                                                <typ:unitPrice><xsl:value-of select="DPH/Zaklad" /></typ:unitPrice>
                                                <typ:price><xsl:value-of select="DPH/Zaklad" /></typ:price>
                                                <typ:priceVAT><xsl:value-of select="DPH/Dan" /></typ:priceVAT>
                                                <typ:priceSum><xsl:value-of select="DPH/Celkem" /></typ:priceSum>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <typ:unitPrice><xsl:value-of select="DPH/Zaklad * -1" /></typ:unitPrice>
                                                <typ:price><xsl:value-of select="DPH/Zaklad * -1" /></typ:price>
                                                <typ:priceVAT><xsl:value-of select="DPH/Dan * -1" /></typ:priceVAT>
                                                <typ:priceSum><xsl:value-of select="DPH/Celkem * -1" /></typ:priceSum>
                                            </xsl:otherwise>  
                                        </xsl:choose>
                                    </inv:homeCurrency>
                                    <inv:classificationVAT>
                                        <typ:ids>UNost</typ:ids>
                                    </inv:classificationVAT>
                                </inv:invoiceItem>
                            </xsl:for-each>
                            <xsl:for-each select="Polozky/PolozkaFakturyVydane[PreneseniDane_ID != '']">
                                <inv:invoiceItem>
                                    <inv:text>RPDP: <xsl:value-of select="Nazev" /></inv:text>
                                    <inv:quantity>1</inv:quantity>
                                    <inv:rateVAT>none</inv:rateVAT>
                                    <inv:homeCurrency>
                                        <xsl:choose>
                                            <xsl:when test="(../../ZapornyPohyb = 'False' and Vratka = 'False') or (../../ZapornyPohyb = 'True' and Vratka = 'True') ">
                                                <typ:unitPrice><xsl:value-of select="DPH/Zaklad" /></typ:unitPrice>
                                                <typ:price><xsl:value-of select="DPH/Zaklad" /></typ:price>
                                                <typ:priceVAT><xsl:value-of select="DPH/Dan" /></typ:priceVAT>
                                                <typ:priceSum><xsl:value-of select="DPH/Celkem" /></typ:priceSum>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <typ:unitPrice><xsl:value-of select="DPH/Zaklad * -1" /></typ:unitPrice>
                                                <typ:price><xsl:value-of select="DPH/Zaklad * -1" /></typ:price>
                                                <typ:priceVAT><xsl:value-of select="DPH/Dan * -1" /></typ:priceVAT>
                                                <typ:priceSum><xsl:value-of select="DPH/Celkem * -1" /></typ:priceSum>
                                            </xsl:otherwise>  
                                        </xsl:choose>
                                    </inv:homeCurrency>
                                    <inv:classificationVAT>
                                        <typ:ids>UDpdp</typ:ids>
                                    </inv:classificationVAT>
                                </inv:invoiceItem>
                            </xsl:for-each>
                        </inv:invoiceDetail>
                        <inv:invoiceSummary>
                            <inv:roundingDocument>math2one</inv:roundingDocument>
                        </inv:invoiceSummary>
                    </inv:invoice>
                </dat:dataPackItem>
            </xsl:for-each>
        </dat:dataPack>
    </xsl:template>
</xsl:stylesheet>