using System;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Text;
using System.IO;

namespace money_xslt
{
    class Program
    {
        static void Main(string[] args)
        {
            string input = args[0];
            string template = args[1];
            string output = args[2];

            XslTransform xslt = new XslTransform();
            xslt.Load(template);
            XPathDocument xpathdocument = new XPathDocument(input);
            using(XmlTextWriter writer = new XmlTextWriter(output, Encoding.UTF8)) {
                xslt.Transform(xpathdocument, null, writer, null);
            }
            string[] lines = File.ReadAllLines(output);

            for (int i = Math.Max(0, lines.Length - 10); i < lines.Length; ++i) {
                Console.WriteLine(lines[i]);
            }
        }
    }
}
