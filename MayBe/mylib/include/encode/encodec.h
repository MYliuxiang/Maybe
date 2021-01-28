#ifndef _ENCODEC_H_
#define _ENCODEC_H_

typedef void (*EncodecPcmCallback)(char *PcmBuffer, int length,int SampleRate,int FormatSize,void *owner);

int  encoudec_date(char *WifiInfo,EncodecPcmCallback  cb,void *owner);

#endif


