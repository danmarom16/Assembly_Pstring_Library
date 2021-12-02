//
// Created by dan on 24/11/2021.
//
#define PSTR_STRT_IDX 49
#define UPP_CHR_STRT 65
#define UPP_CHR_END 90
#define LTL_CHR_STRT 97
#define LTL_CHR_END 122

#include "stdio.h"
#include "pstring.h"

int validate(char firstEndIdx, char secondEndIdx, char i, char j){
    int firstEndIdxAsInt = (int) firstEndIdx;
    int secondEndIdxAsInt = (int)secondEndIdx;
    int iAsInt = (int) i;
    int jAsInt = (int) j;

    if(iAsInt < 0 || iAsInt >= firstEndIdxAsInt || iAsInt >= secondEndIdxAsInt){
        printf("invalid input!\n");
        return 0;
    }
    if(jAsInt < 0 || jAsInt >= firstEndIdxAsInt || jAsInt >= secondEndIdxAsInt){
        printf("invalid input!\n");
        return 0;
    }
    return 1;
}

char toLower(char c){
    int temp = c + 32;
    char ret = (char) temp;
    return ret;
}

char toUpper(char c){
    int temp = c - 32;
    char ret = (char) temp;
    return ret;
}


// return pstr length (without length byte)
char pstrlen(Pstring* pstr){
    return pstr->len;
}

//replace every appearance of oldChar with newChar
Pstring* replaceChar(Pstring* p, char  oldChar, char newChar) {

    int oldCharAsInt = oldChar;
    int newCharAsInt = newChar;
    int temp = 0;
    int if_t;
    int i = 0;

    int for_t = i < (p->len);
    if (!for_t)
        goto forDone;

    // For Body
    forLoop:
        temp = p->str[i];
        if_t = (temp == oldCharAsInt);
        if (if_t)
            goto ifConTrue;
        else
            goto ifConDone;
    ifConTrue:
        p->str[i] = newCharAsInt;
    // End of For Body
    ifConDone:
    i++;
    for_t = i < p->len;
    if(for_t)
        goto forLoop;
    forDone:
        return p;
}



// returns dst after copying scr[i:j] to dst[i:j]
Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j){

    int for_t;
    int val_t = validate(dst->len, src->len, i, j);
    int startIdx, endIdx;


    if(val_t)
        goto valid;
    else
        goto notValid;

    // ifvalid->True: then-statement. Start
    valid:
        startIdx = i;
        endIdx = j;
        for_t = startIdx <= endIdx;
        if (!for_t)
            goto notValid;
    loop:
        dst->str[startIdx] = src->str[startIdx];
        startIdx++;
        for_t = startIdx <= endIdx;
        if(for_t)
            goto loop;
    // ifvalid->True: then-statement. End

    notValid:
        return dst;

}


// swaps upper case to lower case' and lower case to upper case
Pstring* swapCase(Pstring* pstr){
    int temp, for_t, first_if_t, second_if_t, i = 0;
    for_t = i < pstr->len;
    if(!for_t)
        goto forDone;
// for Body-Statement Start
    forLoop:
        temp = pstr->str[i];
    // 1st if
        first_if_t = UPP_CHR_STRT <= temp && temp <= UPP_CHR_END;
        if(first_if_t)
            goto firstIfConTrue;
        else
            goto firstIfDone;
        firstIfConTrue:
            pstr->str[i] = toLower(pstr->str[i]);
        firstIfDone:
        //2nd if
            second_if_t = LTL_CHR_STRT <= temp && temp <= LTL_CHR_END;
            if(second_if_t)
                goto secondIfConTrue;
            else
                goto secondIfConDone;
        secondIfConTrue:
            pstr->str[i] = toUpper(pstr->str[i]);
        secondIfConDone:
        i++;
        for_t = i < pstr->len;
        if(for_t)
            goto forLoop;
// for Body-Statement End
    forDone:
    return pstr;
}

//lexicographic comparison between pstr1[i:j] and pstr2[i:j]
int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j){
   int if_t_o, for_t, if_t_i_first, if_t_i_second, startIdx, endIdx, diff=0;
   if_t_o = validate(pstr1->len, psrt2->len, i, j);
   if(if_t_o)
       goto outerIfTrue;
   else
       goto outerDone;
   outerIfTrue:
        startIdx = i;
        endIdx = j;
        for_t = startIdx < endIdx;
        if(!for_t)
            goto forLoopDone;
        forLoop:
            diff = (pstr1->str[startIdx]) - (psrt2->str[startIdx]);
            // 1st if
            if_t_i_first = (diff > 0);
            if(if_t_i_first)
                goto firstInnerIfTrue;
            else
                goto firstInnerIfDone;
            firstInnerIfTrue:
                return 1;
            firstInnerIfDone:
            // if 1st if is not true - continue to the next one.
            if_t_i_second = (diff < 0);
            if(if_t_i_second)
                goto secondInnerIfTrue;
            else
                goto secondInnerIfDone;
            secondInnerIfTrue:
                return -1;
            secondInnerIfDone:
            // if we got here, both if's are false' which means that the chars are equal.
            // therefore continue for loop, if for loop conditions is still met.
                startIdx++;
                for_t = startIdx < endIdx;
                if(for_t)
                    goto forLoop;
            forLoopDone:
                return 0;
    outerDone:
        return -2;




}
                /* C - Versions Start*/
////-------------------------------------------------////

//// replace every appearance of oldChar with newChar
/*
Pstring* replaceChay(Pstring* p, char  oldChar, char newChar){


    int oldCharAsInt = oldChar;
    int newCharAsInt = newChar;
    int temp = 0;

    for (int i = 0; i < p->len; ++i) {
        temp = p->str[i];
        if (temp== oldCharAsInt) {
            p->str[i] = newCharAsInt;
        }
    }
    return p;
}

*/


//// returns dst after copying scr[i:j] to dst[i:j]
/*
Pstring* pstrijcpyj(Pstring* dst, Pstring* src, char i, char j){
    if(!validate(dst->len, src->len, i, j)){
        return dst;
    }

    int startIdx = i;
    int endIdx = j;

    for (int idx = startIdx; idx <= endIdx; ++idx) {
        dst->str[idx] = src->str[idx];
    }
    return dst;
}
*/

//// swaps upper case to lower case' and lower case to upper case
/*
Pstring* swapCasey(Pstring* pstr){
    int temp;
    for (int i = 0; i < pstr->len; ++i) {
        temp = pstr->str[i];
        if(UPP_CHR_STRT <= temp && temp <= UPP_CHR_END) {
            pstr->str[i] = toLower(pstr->str[i]);
        }
        if(LTL_CHR_STRT <= temp && temp <= LTL_CHR_END) {
            pstr->str[i] = toUpper(pstr->str[i]);
        }
    }
    return pstr;
}
 */

//// lexicographic comparison between pstr1[i:j] and pstr2[i:j]
/*
int pstrijcmpy(Pstring* pstr1, Pstring* psrt2, char i, char j){
    if(!validate(pstr1->len, psrt2->len, i, j)){
        return -2;
    }

    int startIdx = i;
    int endIdx = j ;
    int diff = 0;
    for (int k = startIdx; k < endIdx; ++k) {
        diff = (pstr1->str[k]) - (psrt2->str[k]);
        // pstr1 > pstr2
        if(diff > 0){
            return 1;
        }

        // pstr2 > pstr1
        if(diff < 0){
            return -1;
        }
    }
    return 0;
}
 */

                /* C - Versions - End*/
////-------------------------------------------------////