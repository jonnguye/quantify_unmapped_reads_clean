version 1.0

workflow DetectUnmappedReads{
  input {
    Array[File] bam_files
    Array[String] sample_ids
  }

  scatter (i in range(length(bam_files))) {
    call CheckUnmappedReads {
      input:
        bam_files = bam_files[i],
        sample_id = sample_ids[i]
    }
  }

  output {
    Array[File] unmapped_counts = CheckUnmappedReads.unmapped_counts
  }
}

task CheckUnmappedReads {
  input {
    File bam_file
    String sample_id
  }

  command <<<
  samtools view -c -f4 "~{bam_file}" > "~{sample_id}_unmapped_count.txt"
  >>>

  output {
    File unmapped_count = "~{sample_id}_unmapped_count.txt"
  }

  runtime {
    docker: "quay.io/biocontainers/samtools:1.22--h96c455f_0"
    memory: "2G"
    cpu: 1
  }
}
    
