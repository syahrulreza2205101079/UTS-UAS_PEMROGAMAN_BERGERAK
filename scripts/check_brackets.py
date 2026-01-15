from pathlib import Path
s=Path('lib/main.dart').read_text()
st=[]
pairs={'(':')','[':']','{':'}'}
for i,ch in enumerate(s):
    if ch in '([{':
        st.append((ch,i))
    elif ch in ')]}':
        if not st:
            print('Unmatched closing',ch,'at',i)
            break
        last,li=st.pop()
        if pairs[last]!=ch:
            print('Mismatched',last,'at',li,'with',ch,'at',i)
            break
else:
    if st:
        last,li=st[-1]
        lines=s[:li].split('\n')
        print('Unmatched opening',last,'at line',len(lines),'col',len(lines[-1])+1)
    else:
        print('All matched')
