struc bpb
    .oem_identifier         resb 8
    .bytes_per_sector       resb 2
    .sector_per_cluster     resb 1
    .reserved_sectors       resb 2
    .fat_count              resb 1
    .root_directory_entries resb 2
    .total_sectors          resb 2
    .media_descriptor       resb 1
    .sectors_per_fat        resb 2
    .sectors_per_track      resb 2
    .head_count             resb 2
    .hidden_sectors         resb 4
    .large_sector_count     resb 4
endstruc

struc ebr
    .drive_number           resb 1
    .nt_reserved            resb 1
    .signature              resb 1
    .volume_id              resb 4
    .volume_label           resb 11
    .system_id              resb 8
endstruc
