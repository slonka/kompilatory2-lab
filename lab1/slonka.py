import os
import sys
import re
import codecs

def IsInt(s):
    try: 
        if (int(s) <= 32768 and int(s) >= -32767):
            return True
        else:
            return False
    except ValueError:
        return False

def processFile(filepath):
    fp = codecs.open(filepath, 'rU', 'iso-8859-2')

    content = fp.read()

    # z wszystkiego --------------------
    m_kluczowe = []
    match = re.findall(r'<META NAME="([A-Z|_|0-9]+)" CONTENT="(.+)">', content, re.I)
    if match:
        for i in match:
            #print i[0]
            if i[0] == 'AUTOR':
                m_autor = i[1]                
            elif i[0] == 'DZIAL':
                m_dzial = i[1]
            elif i[0].startswith('KLUCZOWE'):                
                m_kluczowe.append(i[1]);



    
    # z reszty -------------------------
    
    set_calkowite = set()
    

    
    
    
    #liczba zdan
    tekst = re.findall(r"<P>.*?<META", content, re.I | re.DOTALL)
        
    l_calkowitych = 0
    l_zmiennoprzecinkowych = 0
    l_dat = []
    zdania = 0
    s_emaili = set()
    
    if tekst:
        i=tekst[0]
        
        #liczba dat
        #               ____rok____ delim ----miesiac--- BK ^^^^^^^dzien^^^^^^^^^^    
        daty_regexp = r'((19|20)(\d\d))([-.])(0[1-9]|1[012])\4(0[1-9]|[12][0-9]|3[01])'
        #                ----------dzien--------- delim ___miesiac___ BK ^^^rok^^^^
        daty_regexp2 = r'(0[1-9]|[12][0-9]|3[01])([-.])(0[1-9]|1[012])\2((19|20)\d\d)'
        
        m_data = re.finditer(daty_regexp, i)
        m_data2 = re.finditer(daty_regexp2, i)
        l_datNew = []
        
        if m_data:
            for data in m_data:
                l_dat.append([data.group(1), data.group(5), data.group(6)])
                
            for data in m_data2:
                l_dat.append([data.group(4), data.group(3), data.group(1)])
            
            for j in l_dat:
                #print j
                if j not in l_datNew:
                    l_datNew.append(j)
        
        i = re.sub(daty_regexp, r'', i)

        #maile
        maile_regex = r'([a-zA-Z0-9]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,4})'
        m_emaili = re.finditer(maile_regex, i)
        
        for email in m_emaili:            
            s_emaili.add(email.group(1))
        
        i = re.sub(maile_regex, r'', i)
        
        #liczby zmiennoprzecinkowe
        zmiennoprzecinkowe_regex = r'\s[+-]?(\d+\.\d*|\.\d+)([Ee][+-]?\d+)?\s'
        l_zmiennoprzecinkowych += len(re.findall(zmiennoprzecinkowe_regex, i));
        i = re.sub(zmiennoprzecinkowe_regex, r'', i)
        
        l_calkowite = set(re.findall(r"\d+", i))
        
        for liczba in l_calkowite:
            if IsInt(liczba):
                set_calkowite.add(liczba) 
        
        skroty_regex = r'\b[a-zA-Z]{1,3}\.'
        skroty = len( set(re.findall(skroty_regex, i)))
        i = re.sub(skroty_regex, r'', i)
        
        zdania += len(re.findall(r"[.?!]+\s{,1}", i)) + len(re.findall(r'\n+', i, re.DOTALL))
        
    l_calkowitych = len(set_calkowite)
    l_emaili = len(s_emaili)
    l_dat = len(l_datNew)
    
    fp.close()
    print("nazwa pliku: " + filepath)
    print("autor: " + m_autor)
    print("dzial: " + m_dzial)
    
    print("slowa kluczowe: ")
    print ', '.join(m_kluczowe)
    
    print("liczba zdan: " + str(zdania))
    print("liczba skrotow: " + str(skroty) )
    print("liczba liczb calkowitych z zakresu int: " + str(l_calkowitych))
    print("liczba liczb zmiennoprzecinkowych: " + str(l_zmiennoprzecinkowych))
    print("liczba dat: " + str(l_dat))
    print("liczba adresow email: " + str(l_emaili))
    print("\n")



try:
    path = sys.argv[1]
except IndexError:
    print("Brak podanej nazwy katalogu")
    sys.exit(0)


tree = os.walk(path)

for root, dirs, files in tree:
    for f in files:
        if f.endswith(".html"):
            filepath = os.path.join(root, f)
            processFile(filepath)



