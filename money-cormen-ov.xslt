<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output omit-xml-declaration="no" indent="yes" />

    <xsl:template match="S5Data/ObjednavkaVydanaList/ObjednavkaVydana">
        <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
            xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
            <Styles>
                <Style ss:ID="header" ss:Name="Normal">
                    <Font ss:FontName="Verdana" ss:Bold="1" />
                </Style>
            </Styles>
            <Worksheet ss:Name="List1">
                <Table>
                    <Column ss:Index="1" ss:Width="80" />
                    <Row ss:Index="1">
                        <Cell ss:Index="1" ss:StyleID="header">
                            <Data ss:Type="String">Item Code</Data>
                        </Cell>
                        <Cell ss:Index="2" ss:StyleID="header">
                            <Data ss:Type="String">Item name</Data>
                        </Cell>
                        <Cell ss:Index="3" ss:StyleID="header">
                            <Data ss:Type="String">MJ</Data>
                        </Cell>
                        <Cell ss:Index="4" ss:StyleID="header">
                            <Data ss:Type="String">Quantity</Data>
                        </Cell>
                    </Row>
                    <xsl:for-each
                        select="Polozky/PolozkaObjednavkyVydane">
                        <Row ss:Index="{position() + 1}">
                            <Cell ss:Index="1">
                                <Data ss:Type="String">
                                    <xsl:value-of
                                        select="ObsahPolozky/Artikl/Dodavatele/HlavniDodavatel/DodavatelskeOznaceni/Kod" />
                                </Data>
                            </Cell>
                            <Cell ss:Index="2">
                                <Data ss:Type="String"></Data>
                            </Cell>
                            <Cell ss:Index="3">
                                <Data ss:Type="String">KS</Data>
                            </Cell>
                            <Cell ss:Index="4">
                                <Data ss:Type="Number">
                                    <xsl:value-of select="Zbyva" />
                                </Data>
                            </Cell>
                        </Row>
                    </xsl:for-each>
                </Table>
            </Worksheet>
        </Workbook>
    </xsl:template>
</xsl:stylesheet>
