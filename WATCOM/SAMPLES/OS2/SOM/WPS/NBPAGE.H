
#ifndef NBPAGE_H
#define NBPAGE_H

#define WM_USER_UPDATECONTROLS (WM_USER + 0x1000)

MRESULT EXPENTRY NbPageProc( HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);

#endif // NBPAGE_H

