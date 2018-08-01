./bin/iommu.sh

Gives

IOMMU Group 1 01:00.0 3D controller [0302]: NVIDIA Corporation GM107GLM [Quadro M1200 Mobile] [10de:13b6] (rev a2)

Use that to pass through:

echo "10de 13b6" > "/sys/bus/pci/drivers/vfio-pci/new_id"
