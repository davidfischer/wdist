#ifndef __WDIST_ASSOC_H__
#define __WDIST_ASSOC_H__

#include "wdist_common.h"

int32_t model_assoc(pthread_t* threads, FILE* bedfile, int32_t bed_offset, char* outname, char* outname_end, int32_t calculation_type, uint32_t model_modifier, uint32_t model_cell_ct, uint32_t model_mperm_val, double ci_size, double pfilter, uint32_t mtest_adjust, uintptr_t unfiltered_marker_ct, uintptr_t* marker_exclude, uint32_t marker_ct, char* marker_ids, uintptr_t max_marker_id_len, char* marker_alleles, uintptr_t max_marker_allele_len, Chrom_info* chrom_info_ptr, uintptr_t unfiltered_indiv_ct, uintptr_t* indiv_exclude);

#endif // __WDIST_ASSOC_H__