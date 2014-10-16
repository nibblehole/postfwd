#!/usr/local/bin/perl -T
#
# rblcheck.pl - Get RBL (Realtime Blackhole Lists) information without using Socket.pm
#
# USAGE: rblcheck.pl <ip- or email-address>, <ip- or email-address>, ...
#
# JPK


our (%COUNTRIES) = (
	"127.0.3.16" 	=> "AE ; UnitedArabEmirates ; ae.countries.nerd.dk" , 
	"127.0.0.8" 	=> "AL ; Albania ; al.countries.nerd.dk" , 
	"127.0.0.51" 	=> "AM ; Armenia ; am.countries.nerd.dk" , 
	"127.0.2.18" 	=> "AN ; Netherlands Antilles ; an.countries.nerd.dk" , 
	"127.0.0.24" 	=> "AO ; Angola ; ao.countries.nerd.dk" , 
	"127.0.0.32" 	=> "AR ; Argentina ; ar.countries.nerd.dk" , 
	"127.0.0.40" 	=> "AT ; Austria ; at.countries.nerd.dk" , 
	"127.0.0.36" 	=> "AU ; Australia ; au.countries.nerd.dk" , 
	"127.0.0.31" 	=> "AZ ; Azerbaijan ; az.countries.nerd.dk" , 
	"127.0.0.70" 	=> "BA ; Bosnia and Herzegovina ; ba.countries.nerd.dk" , 
	"127.0.0.52" 	=> "BB ; Barbados ; bb.countries.nerd.dk" , 
	"127.0.0.50" 	=> "BD ; Bangladesh ; bd.countries.nerd.dk" , 
	"127.0.0.56" 	=> "BE ; Belgium ; be.countries.nerd.dk" , 
	"127.0.3.86" 	=> "BF ; Burkina Faso ; bf.countries.nerd.dk" , 
	"127.0.0.100" 	=> "BG ; Bulgaria ; bg.countries.nerd.dk" , 
	"127.0.0.48" 	=> "BH ; Bahrain ; bh.countries.nerd.dk" , 
	"127.0.0.60" 	=> "BM ; Bermuda ; bm.countries.nerd.dk" , 
	"127.0.0.96" 	=> "BN ; Brunei Darussalam ; bn.countries.nerd.dk" , 
	"127.0.0.68" 	=> "BO ; Bolivia ; bo.countries.nerd.dk" , 
	"127.0.0.76" 	=> "BR ; Brazil ; br.countries.nerd.dk" , 
	"127.0.0.44" 	=> "BS ; Bahamas ; bs.countries.nerd.dk" , 
	"127.0.0.64" 	=> "BT ; Bhutan ; bt.countries.nerd.dk" , 
	"127.0.0.72" 	=> "BW ; Botswana ; bw.countries.nerd.dk" , 
	"127.0.0.112" 	=> "BY ; Belarus ; by.countries.nerd.dk" , 
	"127.0.0.84" 	=> "BZ ; Belize ; bz.countries.nerd.dk" , 
	"127.0.0.124" 	=> "CA ; Canada ; ca.countries.nerd.dk" , 
	"127.0.2.244" 	=> "CH ; Switzerland ; ch.countries.nerd.dk" , 
	"127.0.0.184" 	=> "CK ; Cook Islands ; ck.countries.nerd.dk" , 
	"127.0.0.152" 	=> "CL ; Chile ; cl.countries.nerd.dk" , 
	"127.0.0.120" 	=> "CM ; Cameroon ; cm.countries.nerd.dk" , 
	"127.0.0.156" 	=> "CN ; China ; cn.countries.nerd.dk" , 
	"127.0.0.170" 	=> "CO ; Colombia ; co.countries.nerd.dk" , 
	"127.0.0.188" 	=> "CR ; Costa Rica ; cr.countries.nerd.dk" , 
	"127.0.0.192" 	=> "CU ; Cuba ; cu.countries.nerd.dk" , 
	"127.0.0.196" 	=> "CY ; Cyprus ; cy.countries.nerd.dk" , 
	"127.0.0.203" 	=> "CZ ; Czech Republic ; cz.countries.nerd.dk" , 
	"127.0.1.20" 	=> "DE ; Germany ; de.countries.nerd.dk" , 
	"127.0.0.208" 	=> "DK ; Denmark ; dk.countries.nerd.dk" , 
	"127.0.0.214" 	=> "DO ; Dominican Republic ; do.countries.nerd.dk" , 
	"127.0.0.12" 	=> "DZ ; Algeria ; dz.countries.nerd.dk" , 
	"127.0.0.218" 	=> "EC ; Ecuador ; ec.countries.nerd.dk" , 
	"127.0.0.233" 	=> "EE ; Estonia ; ee.countries.nerd.dk" , 
	"127.0.3.50" 	=> "EG ; Egypt ; eg.countries.nerd.dk" , 
	"127.0.2.212" 	=> "ES ; Spain ; es.countries.nerd.dk" , 
	"127.0.0.231" 	=> "ET ; Ethiopia ; et.countries.nerd.dk" , 
	"127.0.0.246" 	=> "FI ; Finland ; fi.countries.nerd.dk" , 
	"127.0.0.242" 	=> "FJ ; Fiji ; fj.countries.nerd.dk" , 
	"127.0.0.234" 	=> "FO ; Faroe Islands ; fo.countries.nerd.dk" , 
	"127.0.0.250" 	=> "FR ; France ; fr.countries.nerd.dk" , 
	"127.0.1.10" 	=> "GA ; Gabon ; ga.countries.nerd.dk" , 
	"127.0.3.58" 	=> "GB ; GB ; gb.countries.nerd.dk" , 
	"127.0.1.52" 	=> "GD ; Grenada ; gd.countries.nerd.dk" , 
	"127.0.1.12" 	=> "GE ; Georgia ; ge.countries.nerd.dk" , 
	"127.0.1.32" 	=> "GH ; Ghana ; gh.countries.nerd.dk" , 
	"127.0.1.36" 	=> "GI ; Gibraltar ; gi.countries.nerd.dk" , 
	"127.0.1.48" 	=> "GL ; Greenland ; gl.countries.nerd.dk" , 
	"127.0.1.14" 	=> "GM ; Gambia ; gm.countries.nerd.dk" , 
	"127.0.1.68" 	=> "GN ; Guinea ; gn.countries.nerd.dk" , 
	"127.0.1.44" 	=> "GR ; Greece ; gr.countries.nerd.dk" , 
	"127.0.1.64" 	=> "GT ; Guatemala ; gt.countries.nerd.dk" , 
	"127.0.1.60" 	=> "GU ; Guam ; gu.countries.nerd.dk" , 
	"127.0.1.88" 	=> "HK ; Hong Kong ; hk.countries.nerd.dk" , 
	"127.0.1.84" 	=> "HN ; Honduras ; hn.countries.nerd.dk" , 
	"127.0.0.191" 	=> "HR ; Croatia/Hrvatska ; hr.countries.nerd.dk" , 
	"127.0.1.76" 	=> "HT ; Haiti ; ht.countries.nerd.dk" , 
	"127.0.1.92" 	=> "HU ; Hungary ; hu.countries.nerd.dk" , 
	"127.0.1.104" 	=> "ID ; Indonesia ; id.countries.nerd.dk" , 
	"127.0.1.116" 	=> "IE ; Ireland ; ie.countries.nerd.dk" , 
	"127.0.1.120" 	=> "IL ; Israel ; il.countries.nerd.dk" , 
	"127.0.1.100" 	=> "IN ; India ; in.countries.nerd.dk" , 
	"127.0.0.86" 	=> "IO ; British Indian Ocean Territory ; io.countries.nerd.dk" , 
	"127.0.1.108" 	=> "IR ; Iran (Islamic Republic of) ; ir.countries.nerd.dk" , 
	"127.0.1.96" 	=> "IS ; Iceland ; is.countries.nerd.dk" , 
	"127.0.1.124" 	=> "IT ; Italy ; it.countries.nerd.dk" , 
	"127.0.1.132" 	=> "JM ; Jamaica ; jm.countries.nerd.dk" , 
	"127.0.1.144" 	=> "JO ; Jordan ; jo.countries.nerd.dk" , 
	"127.0.1.136" 	=> "JP ; Japan ; jp.countries.nerd.dk" , 
	"127.0.1.148" 	=> "KE ; Kenya ; ke.countries.nerd.dk" , 
	"127.0.1.161" 	=> "KG ; Kyrgyzstan ; kg.countries.nerd.dk" , 
	"127.0.0.116" 	=> "KH ; Cambodia ; kh.countries.nerd.dk" , 
	"127.0.1.154" 	=> "KR ; Korea, Republic of ; kr.countries.nerd.dk" , 
	"127.0.1.158" 	=> "KW ; Kuwait ; kw.countries.nerd.dk" , 
	"127.0.1.142" 	=> "KZ ; Kazakhstan ; kz.countries.nerd.dk" , 
	"127.0.1.162" 	=> "LA ; Lao People's Democratic Republic ; la.countries.nerd.dk" , 
	"127.0.1.166" 	=> "LB ; Lebanon ; lb.countries.nerd.dk" , 
	"127.0.1.182" 	=> "LI ; Liechtenstein ; li.countries.nerd.dk" , 
	"127.0.0.144" 	=> "LK ; Sri Lanka ; lk.countries.nerd.dk" , 
	"127.0.1.170" 	=> "LS ; Lesotho ; ls.countries.nerd.dk" , 
	"127.0.1.184" 	=> "LT ; Lithuania ; lt.countries.nerd.dk" , 
	"127.0.1.186" 	=> "LU ; Luxembourg ; lu.countries.nerd.dk" , 
	"127.0.1.172" 	=> "LV ; Latvia ; lv.countries.nerd.dk" , 
	"127.0.1.178" 	=> "LY ; Libyan Arab Jamahiriya ; ly.countries.nerd.dk" , 
	"127.0.1.248" 	=> "MA ; Morocco ; ma.countries.nerd.dk" , 
	"127.0.1.236" 	=> "MC ; Monaco ; mc.countries.nerd.dk" , 
	"127.0.1.242" 	=> "MD ; Moldova, Republic of ; md.countries.nerd.dk" , 
	"127.0.3.39" 	=> "MK ; Macedonia, Former Yugoslav Republic ; mk.countries.nerd.dk" , 
	"127.0.1.210" 	=> "ML ; Mali ; ml.countries.nerd.dk" , 
	"127.0.0.104" 	=> "MM ; Myanmar ; mm.countries.nerd.dk" , 
	"127.0.1.240" 	=> "MN ; Mongolia ; mn.countries.nerd.dk" , 
	"127.0.1.190" 	=> "MO ; Macau ; mo.countries.nerd.dk" , 
	"127.0.1.214" 	=> "MT ; Malta ; mt.countries.nerd.dk" , 
	"127.0.1.224" 	=> "MU ; Mauritius ; mu.countries.nerd.dk" , 
	"127.0.1.206" 	=> "MV ; Maldives ; mv.countries.nerd.dk" , 
	"127.0.1.228" 	=> "MX ; Mexico ; mx.countries.nerd.dk" , 
	"127.0.1.202" 	=> "MY ; Malaysia ; my.countries.nerd.dk" , 
	"127.0.1.252" 	=> "MZ ; Mozambique ; mz.countries.nerd.dk" , 
	"127.0.2.4" 	=> "NA ; Namibia ; na.countries.nerd.dk" , 
	"127.0.2.28" 	=> "NC ; New Caledonia ; nc.countries.nerd.dk" , 
	"127.0.2.50" 	=> "NE ; Niger ; ne.countries.nerd.dk" , 
	"127.0.2.54" 	=> "NG ; Nigeria ; ng.countries.nerd.dk" , 
	"127.0.2.46" 	=> "NI ; Nicaragua ; ni.countries.nerd.dk" , 
	"127.0.2.16" 	=> "NL ; Netherlands ; nl.countries.nerd.dk" , 
	"127.0.2.66" 	=> "NO ; Norway ; no.countries.nerd.dk" , 
	"127.0.2.12" 	=> "NP ; Nepal ; np.countries.nerd.dk" , 
	"127.0.2.8" 	=> "NR ; Nauru ; nr.countries.nerd.dk" , 
	"127.0.2.42" 	=> "NZ ; New Zealand ; nz.countries.nerd.dk" , 
	"127.0.2.0" 	=> "OM ; Oman ; om.countries.nerd.dk" , 
	"127.0.2.79" 	=> "PA ; Panama ; pa.countries.nerd.dk" , 
	"127.0.2.92" 	=> "PE ; Peru ; pe.countries.nerd.dk" , 
	"127.0.1.2" 	=> "PF ; French Polynesia ; pf.countries.nerd.dk" , 
	"127.0.2.86" 	=> "PG ; Papua New Guinea ; pg.countries.nerd.dk" , 
	"127.0.2.96" 	=> "PH ; Philippines ; ph.countries.nerd.dk" , 
	"127.0.2.74" 	=> "PK ; Pakistan ; pk.countries.nerd.dk" , 
	"127.0.2.104" 	=> "PL ; Poland ; pl.countries.nerd.dk" , 
	"127.0.2.118" 	=> "PR ; Puerto Rico ; pr.countries.nerd.dk" , 
	"127.0.2.108" 	=> "PT ; Portugal ; pt.countries.nerd.dk" , 
	"127.0.2.88" 	=> "PY ; Paraguay ; py.countries.nerd.dk" , 
	"127.0.2.122" 	=> "QA ; Qatar ; qa.countries.nerd.dk" , 
	"127.0.2.130" 	=> "RO ; Romania ; ro.countries.nerd.dk" , 
	"127.0.2.131" 	=> "RU ; Russian Federation ; ru.countries.nerd.dk" , 
	"127.0.2.170" 	=> "SA ; Saudi Arabia ; sa.countries.nerd.dk" , 
	"127.0.0.90" 	=> "SB ; Solomon Islands ; sb.countries.nerd.dk" , 
	"127.0.2.224" 	=> "SD ; Sudan ; sd.countries.nerd.dk" , 
	"127.0.2.240" 	=> "SE ; Sweden ; se.countries.nerd.dk" , 
	"127.0.2.190" 	=> "SG ; Singapore ; sg.countries.nerd.dk" , 
	"127.0.2.193" 	=> "SI ; Slovenia ; si.countries.nerd.dk" , 
	"127.0.2.191" 	=> "SK ; Slovak Republic ; sk.countries.nerd.dk" , 
	"127.0.2.182" 	=> "SL ; Sierra Leone ; sl.countries.nerd.dk" , 
	"127.0.2.162" 	=> "SM ; San Marino ; sm.countries.nerd.dk" , 
	"127.0.2.174" 	=> "SN ; Senegal ; sn.countries.nerd.dk" , 
	"127.0.2.228" 	=> "SR ; Suriname ; sr.countries.nerd.dk" , 
	"127.0.0.222" 	=> "SV ; El Salvador ; sv.countries.nerd.dk" , 
	"127.0.2.248" 	=> "SY ; Syrian Arab Republic ; sy.countries.nerd.dk" , 
	"127.0.2.236" 	=> "SZ ; Swaziland ; sz.countries.nerd.dk" , 
	"127.0.3.0" 	=> "TG ; Togo ; tg.countries.nerd.dk" , 
	"127.0.2.252" 	=> "TH ; Thailand ; th.countries.nerd.dk" , 
	"127.0.3.27" 	=> "TM ; Turkmenistan ; tm.countries.nerd.dk" , 
	"127.0.3.20" 	=> "TN ; Tunisia ; tn.countries.nerd.dk" , 
	"127.0.3.8" 	=> "TO ; Tonga ; to.countries.nerd.dk" , 
	"127.0.3.24" 	=> "TR ; Turkey ; tr.countries.nerd.dk" , 
	"127.0.3.12" 	=> "TT ; Trinidad and Tobago ; tt.countries.nerd.dk" , 
	"127.0.3.30" 	=> "TV ; Tuvalu ; tv.countries.nerd.dk" , 
	"127.0.0.158" 	=> "TW ; Taiwan ; tw.countries.nerd.dk" , 
	"127.0.3.66" 	=> "TZ ; Tanzania ; tz.countries.nerd.dk" , 
	"127.0.3.36" 	=> "UA ; Ukraine ; ua.countries.nerd.dk" , 
	"127.0.3.32" 	=> "UG ; Uganda ; ug.countries.nerd.dk" , 
	"127.0.3.58" 	=> "UK ; United Kingdom ; uk.countries.nerd.dk" , 
	"127.0.3.72" 	=> "US ; United States ; us.countries.nerd.dk" , 
	"127.0.3.90" 	=> "UY ; Uruguay ; uy.countries.nerd.dk" , 
	"127.0.3.92" 	=> "UZ ; Uzbekistan ; uz.countries.nerd.dk" , 
	"127.0.1.80" 	=> "VA ; Holy See (City Vatican State) ; va.countries.nerd.dk" , 
	"127.0.3.94" 	=> "VE ; Venezuela ; ve.countries.nerd.dk" , 
	"127.0.2.192" 	=> "VN ; Vietnam ; vn.countries.nerd.dk" , 
	"127.0.2.36" 	=> "VU ; Vanuatu ; vu.countries.nerd.dk" , 
	"127.0.3.114" 	=> "WS ; Western Samoa ; ws.countries.nerd.dk" , 
	"127.0.3.119" 	=> "YE ; Yemen ; ye.countries.nerd.dk" , 
	"127.0.3.123" 	=> "YU ; Yugoslavia ; yu.countries.nerd.dk" , 
	"127.0.2.198" 	=> "ZA ; South Africa ; za.countries.nerd.dk" , 
	"127.0.2.204" 	=> "ZW ; Zimbabwe ; zw.countries.nerd.dk" , 
);

our (%RWLs) = (
        #
        # Name of Whitelist             => result-pattern (means "listed")
        #
        "query.bondedsender.org"        => '^127\.0\.0\.\d+$' ,
        "exemptions.ahbl.org"           => '^127\.0\.0\.\d+$' ,
        "spf.trusted-forwarder.org"     => '^127\.0\.0\.\d+$' ,
        "list.dnswl.org"                => '^127\.0\.0\.\d+$' ,
        "zz.countries.nerd.dk"          => '.*' ,
);

our (%RBLs) = (
        #
        # Name of RBL                   => result-pattern (means "listed")
        #
        "zen.spamhaus.org"              => '^127\.0\.0\.\d+$' ,
        "bl.spamcop.net"                => '^127\.0\.0\.\d+$' ,
        "list.dsbl.org"                 => '^127\.0\.0\.\d+$' ,
        "multihop.dsbl.org"             => '^127\.0\.0\.\d+$' ,
        "unconfirmed.dsbl.org"          => '^127\.0\.0\.\d+$' ,
        "combined.njabl.org"            => '^127\.0\.0\.\d+$' ,
        "dnsbl.sorbs.net"               => '^127\.0\.0\.\d+$' ,
        "dnsbl.ahbl.org"                => '^127\.0\.0\.\d+$' ,
        "ix.dnsbl.manitu.net"           => '^127\.0\.0\.\d+$' ,
        #
        # experimental
        "dnsbl-1.uceprotect.net"        => '^127\.0\.0\.\d+$' ,
        "dnsbl-2.uceprotect.net"        => '^127\.0\.0\.\d+$' ,
        "dnsbl-3.uceprotect.net"        => '^127\.0\.0\.\d+$' ,
        "ips.backscatterer.org"         => '^127\.0\.0\.\d+$' ,
        "sorbs.dnsbl.net.au"            => '^127\.0\.0\.\d+$' ,
        "korea.services.net"            => '^127\.0\.0\.\d+$' ,
        "blackholes.five-ten-sg.com"    => '^127\.0\.0\.\d+$' ,
        "cbl.anti-spam.org.cn"          => '^127\.0\.0\.\d+$' ,
        "cblplus.anti-spam.org.cn"      => '^127\.0\.0\.\d+$' ,
        "cblless.anti-spam.org.cn"      => '^127\.0\.0\.\d+$' ,
        "bogons.cymru.com"              => '^127\.0\.0\.\d+$' ,
);

our (%RHSBLs) = (
        #
        # Name of RHSBL                 => result-pattern (means "listed")
        #
        "rhsbl.sorbs.net"               => '^127\.0\.0\.\d+$' ,
        "rhsbl.ahbl.org"                => '^127\.0\.0\.\d+$' ,
        "multi.surbl.org"               => '^127\.0\.0\.\d+$' ,
        "dsn.rfc-ignorant.org"          => '^127\.0\.0\.\d+$' ,
        "whois.rfc-ignorant.org"        => '^127\.0\.0\.\d+$' ,
        "bogusmx.rfc-ignorant.org"      => '^127\.0\.0\.\d+$' ,
        "blackhole.securitysage.com"    => '^127\.0\.0\.\d+$' ,
        "ex.dnsbl.org"                  => '^127\.0\.0\.\d+$' ,
        "rddn.dnsbl.net.au"             => '^127\.0\.0\.\d+$' ,
        "block.rhs.mailpolice.com"      => '^127\.0\.0\.\d+$' ,
        "dynamic.rhs.mailpolice.com"    => '^127\.0\.0\.\d+$' ,
        "dnsbl.cyberlogic.net"          => '^127\.0\.0\.\d+$' ,
);

our($up) = 'C4';

foreach $arg (@ARGV) {
        $arg =~ s/[\[\]]//g;
        if ($arg =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/) {
                # header
                $rname = gethostbyaddr (pack ($up, (split /\./, $arg)), 2);
                $rname = 'unknown' unless $rname;
                printf "\n\t CLIENT: %s\n", $rname;
                print "\t".("-" x (length($rname) + 10))."\n";

                # RWL checks
                foreach $rwl ( sort keys(%RWLs) ) {
                        $ip = join(".", reverse(split(/\./, $arg))) .".".$rwl;
                        my($mybegin) = time();
                        my($g1,$g2,$g3,$g4,@addrs) = gethostbyname($ip);
                        my($myend) = time();
                        $myresult = join (".", unpack ($up, $addrs[0]));
                        printf "\t%-36s  query time: %2ds", "RWL   ".$rwl, ($myend - $mybegin);
                        ( $myresult =~ /$RWLs{$rwl}/ ) ? printf "  ->  LISTED (%s)", $myresult : printf "  ->  not listed";
                        printf " Country: %s", $COUNTRIES{$myresult} if ($myresult and exists $COUNTRIES{$myresult});
                        print "\n";
                };
                # RBL checks
                foreach $rbl ( sort keys(%RBLs) ) {
                        $ip = join(".", reverse(split(/\./, $arg))) .".".$rbl;
                        my($mybegin) = time();
                        my($g1,$g2,$g3,$g4,@addrs) = gethostbyname($ip);
                        my($myend) = time();
                        $myresult = join (".", unpack ($up, $addrs[0]));
                        printf "\t%-36s  query time: %2ds", "RBL   ".$rbl, ($myend - $mybegin);
                        ( $myresult =~ /$RBLs{$rbl}/ ) ? printf "  ->  LISTED (%s)", $myresult : printf "  ->  not listed";
			print "\n";
                };
        } else {
                $rname = (split /\@/, $arg)[1];
                printf "\n\t DOMAIN: %s\n", $rname;
                print "\t".("-" x (length($rname) + 10))."\n";
        };

        # RHSBL checks
        unless ($rname eq 'unknown') {
                foreach $rhsbl ( sort keys(%RHSBLs) ) {
                        $myquery = $rname.".".$rhsbl;
                        my($mybegin) = time();
                        my($g1,$g2,$g3,$g4,@addrs) = gethostbyname($myquery);
                        my($myend) = time();
                        $myresult = join (".", unpack ($up, $addrs[0]));
                        printf "\t%-36s  query time: %2ds", "RHSBL ".$rhsbl, ($myend - $mybegin);
                        ( $myresult =~ /$RHSBLs{$rhsbl}/ ) ? printf "  ->  LISTED (%s)", $myresult : printf "  ->  not listed";
                        print "\n";
                };
        };
};
print "\n";

