package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/osm/quake/common/lump"
	"github.com/osm/quake/common/lump/miptex"
	"github.com/osm/quake/common/lump/qpic"
	"github.com/osm/quake/common/wad"
)

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintf(os.Stderr, "usage: %s <input directory> <wad file>\n", os.Args[0])
		os.Exit(1)
	}

	inputDirPath := os.Args[1]
	wadFilePath := os.Args[2]

	var wadFile wad.Wad
	for _, name := range wadFiles {
		ext := "qpic"
		if name == "CONCHARS" {
			ext = "miptex"
		}

		filePath := filepath.Join(inputDirPath, name) + "." + ext
		data, err := os.ReadFile(filePath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "failed to open file: %s %v\n", filePath, err)
		}

		lmp, err := toLump(data, ext)
		if err != nil {
			fmt.Fprintf(os.Stderr, "failed to parse lump: %s %v\n", filePath, err)
		}

		wadFile.Entries = append(wadFile.Entries, &wad.Entry{
			Name:        name,
			Type:        lmp.Type(),
			Compression: 0,
			Lump:        lmp,
		})
	}

	filePath := filepath.Join(wadFilePath)
	if err := ioutil.WriteFile(filePath, wadFile.Bytes(), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "unable to create file %s, %v", filePath, err)
		os.Exit(1)
	}
}

func toLump(data []byte, typ string) (lump.LumpData, error) {
	switch typ {
	case "qpic":
		return qpic.Parse(data)
	case "miptex":
		return miptex.Parse(128, 128, data)
	default:
		return nil, errors.New("unknown lump format")
	}
}

var wadFiles = []string{
	"NUM_0",
	"NUM_1",
	"NUM_2",
	"NUM_3",
	"NUM_4",
	"NUM_5",
	"NUM_6",
	"NUM_7",
	"NUM_8",
	"NUM_9",
	"NUM_MINUS",
	"ANUM_0",
	"ANUM_1",
	"ANUM_2",
	"ANUM_3",
	"ANUM_4",
	"ANUM_5",
	"ANUM_6",
	"ANUM_7",
	"ANUM_8",
	"ANUM_9",
	"ANUM_MINUS",
	"NUM_SLASH",
	"NUM_COLON",
	"SBAR",
	"IBAR",
	"SCOREBAR",
	"SB_ARMOR1",
	"SB_ARMOR2",
	"SB_ARMOR3",
	"SB_ROCKET",
	"SB_SHELLS",
	"SB_NAILS",
	"SB_CELLS",
	"INV_ROCKET",
	"INV_NAILS",
	"INV_SHELLS",
	"INV_SHOTGUN",
	"INV_SSHOTGUN",
	"INV_NAILGUN",
	"INV_SNAILGUN",
	"INV_RLAUNCH",
	"INV_SRLAUNCH",
	"SB_KEY2",
	"SB_KEY1",
	"INV_LIGHTNG",
	"SBA1_KEY2",
	"SBA2_KEY2",
	"SBA3_KEY2",
	"SBA4_KEY2",
	"SBA5_KEY2",
	"SBA1_KEY1",
	"SBA2_KEY1",
	"SBA3_KEY1",
	"SBA4_KEY1",
	"SBA5_KEY1",
	"SB_INVIS",
	"SB_INVULN",
	"SB_SUIT",
	"SB_QUAD",
	"SBA1_INVIS",
	"SBA2_INVIS",
	"SBA3_INVIS",
	"SBA4_INVIS",
	"SBA5_INVIS",
	"SBA1_INVUL",
	"SBA2_INVUL",
	"SBA3_INVUL",
	"SBA4_INVUL",
	"SBA5_INVUL",
	"SBA1_SUIT",
	"SBA2_SUIT",
	"SBA3_SUIT",
	"SBA4_SUIT",
	"SBA5_SUIT",
	"SBA1_QUAD",
	"SBA2_QUAD",
	"SBA3_QUAD",
	"SBA4_QUAD",
	"SBA5_QUAD",
	"SB_SIGIL1",
	"SB_SIGIL2",
	"SB_SIGIL3",
	"SB_SIGIL4",
	"INV2_SHOTGUN",
	"INV2_SSHOTGUN",
	"INV2_NAILGUN",
	"INV2_SNAILGUN",
	"INV2_RLAUNCH",
	"INV2_SRLAUNCH",
	"INV2_LIGHTNG",
	"INVA1_SHOTGUN",
	"INVA2_SHOTGUN",
	"INVA3_SHOTGUN",
	"INVA4_SHOTGUN",
	"INVA5_SHOTGUN",
	"INVA1_SSHOTGUN",
	"INVA2_SSHOTGUN",
	"INVA3_SSHOTGUN",
	"INVA4_SSHOTGUN",
	"INVA5_SSHOTGUN",
	"INVA1_NAILGUN",
	"INVA2_NAILGUN",
	"INVA3_NAILGUN",
	"INVA4_NAILGUN",
	"INVA5_NAILGUN",
	"INVA1_SNAILGUN",
	"INVA2_SNAILGUN",
	"INVA3_SNAILGUN",
	"INVA4_SNAILGUN",
	"INVA5_SNAILGUN",
	"INVA1_RLAUNCH",
	"INVA2_RLAUNCH",
	"INVA3_RLAUNCH",
	"INVA4_RLAUNCH",
	"INVA5_RLAUNCH",
	"INVA1_SRLAUNCH",
	"INVA2_SRLAUNCH",
	"INVA3_SRLAUNCH",
	"INVA4_SRLAUNCH",
	"INVA5_SRLAUNCH",
	"INVA1_LIGHTNG",
	"INVA2_LIGHTNG",
	"INVA3_LIGHTNG",
	"INVA4_LIGHTNG",
	"INVA5_LIGHTNG",
	"FACE1",
	"FACE2",
	"FACE3",
	"FACE4",
	"FACE5",
	"FACE_P1",
	"FACE_P2",
	"FACE_P3",
	"FACE_P4",
	"FACE_P5",
	"FACE_INVIS",
	"FACE_INVUL1",
	"FACE_INVUL2",
	"FACE_INV2",
	"FACE_QUAD",
	"CONCHARS",
	"BACKTILE",
	"IN_1",
	"IN_2",
	"IN_3",
	"IN_4",
	"IN_5",
	"IN_6",
	"IN_7",
	"IN_8",
	"OUT_1",
	"OUT_2",
	"OUT_3",
	"OUT_4",
	"OUT_5",
	"OUT_6",
	"OUT_7",
	"OUT_8",
	"RAM",
	"NET",
	"TURTLE",
	"DISC",
}
