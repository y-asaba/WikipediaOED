<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:ns1="http://www.microsoft.com/ime/dctx"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:user="urn:my-scripts"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/> 

  <msxsl:script language="C#" implements-prefix="user">
	<![CDATA[
	public string GetReadingFromAbstract(string abstract_string)
	{
		// 「あ～と」ではじまるよみだけ
		Regex r = new Regex("^[^(（]+[\\(（]([あ-とア-ト][^\\)）、,;]+)[\\)）、,;]");
		Match m = r.Match(abstract_string);
		return m.Groups[1].Value;
	}

	public string KatakanaToHiragana(string hiragana)
	{
		string katakana = "";
		foreach (char c in hiragana)
		{
			char c1 = c;
			if (Regex.IsMatch(c.ToString(), "[ア-ン]"))
			{
				c1 = (char)(c - 96);
			}
			katakana += c1.ToString();
		}
		return katakana;
	}

	public string RemoveParenthesis(string word)
	{
		if (word.Contains("(")) // half-width parenthesis
		{
			Regex r = new Regex("^([^(]+)\\(");
			Match m = r.Match(word);
			return m.Groups[1].Value;
		}
		else if (word.Contains("（")) // full-width parenthesis
		{
			Regex r = new Regex("^([^（]+)（");
			Match m = r.Match(word);
			return m.Groups[1].Value;
		}
		else
			return word;
	}

	public bool IsValidReading(string reading)
	{
		return Regex.IsMatch(reading, @"^(\p{IsHiragana}|ヴ|ー)+$");
	}

	public string GenerateDictionaryGuid()
	{
		Guid dictId = Guid.NewGuid();
		return "{" + dictId.ToString().ToUpper() + "}";
	}
	]]>
  </msxsl:script>


  <xsl:template match="/feed">
	<ns1:Dictionary xmlns:ns1="http://www.microsoft.com/ime/dctx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
 <ns1:DictionaryHeader> 
  <ns1:DictionaryGUID><xsl:value-of select="user:GenerateDictionaryGuid()" /></ns1:DictionaryGUID> 
  <ns1:DictionaryLanguage>ja-jp</ns1:DictionaryLanguage> 
  <ns1:DictionaryVersion>1</ns1:DictionaryVersion> 
  <ns1:SourceURL>http://download.wikimedia.org/jawiki/</ns1:SourceURL> 
  <ns1:CommentInsertion>true</ns1:CommentInsertion> 
  <ns1:DictionaryInfo Language="ja-jp"> 
   <ns1:ShortName>Wikipedia辞書(あ～と)</ns1:ShortName> 
   <ns1:LongName>日本のWikipedia辞書(あ～と)</ns1:LongName> 
   <ns1:Description>Wikipediaから生成した辞書です</ns1:Description> 
   <ns1:Copyright>この辞書はウィキペディア(http://ja.wikipedia.org/)のテキストを利用しています。テキストはクリエイティブ・コモンズ 表示-継承ライセンス(CC-BY-SA)の下で利用可能です。追加の条件が適用される場合があります。詳細はウィキペディアの利用規約を参照してください。ライセンスのURL： http://creativecommons.org/licenses/by-sa/3.0/deed.ja </ns1:Copyright> 
   <ns1:CommentHeader1>概要</ns1:CommentHeader1> 
  </ns1:DictionaryInfo> 
  <ns1:DictionaryInfo Language="en-us"> 
   <ns1:ShortName>Wikipedia Dictionary(あ～と)</ns1:ShortName> 
   <ns1:LongName>Japanese Wikipedia Dictionary(あ～と)</ns1:LongName> 
   <ns1:Description>This dictionary is based on Japanese Wikipedia data.</ns1:Description> 
   <ns1:Copyright>Wikipedia data is available under the Creative Commons Attribution/Share-Alike License (http://creativecommons.org/licenses/by-sa/3.0/legalcode) ; additional terms may apply. See Terms of Use (http://wikimediafoundation.org/wiki/Terms_of_Use) for details.   </ns1:Copyright> 
   <ns1:CommentHeader1>Abstract</ns1:CommentHeader1> 
  </ns1:DictionaryInfo> 
 </ns1:DictionaryHeader> 
	  <xsl:apply-templates select="doc"/>
	</ns1:Dictionary> 
  </xsl:template> 

  <xsl:template match="doc">
	<xsl:variable name="title" select="user:RemoveParenthesis(substring-after(title, 'Wikipedia: '))" />
	<xsl:variable name="reading" select="translate(user:KatakanaToHiragana(user:GetReadingFromAbstract(abstract)), ' ', '')" />
	<xsl:variable name="hiragana" select="user:IsValidReading($reading)" />
	<xsl:if test="($reading != '') and $hiragana">
		<ns1:DictionaryEntry>
			<ns1:InputString>
				<xsl:value-of select="$reading" />
			</ns1:InputString>
			<ns1:OutputString>
				<xsl:value-of select="translate($title, ' ', '')" />
			</ns1:OutputString>
			  <ns1:PartOfSpeech>Noun</ns1:PartOfSpeech> 
			  <ns1:CommentData1><xsl:value-of select="abstract" /></ns1:CommentData1> 
			  <ns1:URL><xsl:value-of select="url" /></ns1:URL> 
			  <ns1:Priority>200</ns1:Priority> 
			  <ns1:ReverseConversion>true</ns1:ReverseConversion> 
			  <ns1:CommonWord>false</ns1:CommonWord> 
		</ns1:DictionaryEntry>
	</xsl:if>
  </xsl:template>

</xsl:stylesheet> 
