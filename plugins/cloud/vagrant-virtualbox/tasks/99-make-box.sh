/usr/lib/virtualbox/VBoxManage convertfromraw --format VMDK --variant Stream "$IMAGEFILE" "${WORKSPACE}/box-disk1.vmdk"

cat <<EOF >"${WORKSPACE}/metadata.json"
{
  "provider":     "virtualbox"
}
EOF

macaddr="0200$(uuidgen | cut -d '-' -f 1)"
hdduuid="$(uuidgen)"


cat <<EOF >"${WORKSPACE}/Vagrantfile"
Vagrant.configure("2") do |config|
  config.vm.base_mac = "${macaddr}"
end
EOF

cat <<EOF >"${WORKSPACE}/box.ovf"
<?xml version="1.0"?>
<Envelope ovf:version="1.0" xml:lang="en-US" xmlns="http://schemas.dmtf.org/ovf/envelope/1" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" xmlns:vssd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:vbox="http://www.virtualbox.org/ovf/machine">
  <References>
    <File ovf:href="box-disk1.vmdk" ovf:id="file1"/>
  </References>
  <DiskSection>
    <Info>List of the virtual disks used in the package</Info>
    <Disk ovf:capacity="$(($(optval image-size) * 1048576 * 1024))" ovf:diskId="vmdisk1" ovf:fileRef="file1" ovf:format="http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized" vbox:uuid="$hdduuid"/>
  </DiskSection>
  <NetworkSection>
    <Info>Logical networks used in the package</Info>
    <Network ovf:name="HostOnly">
      <Description>Logical network used by this appliance.</Description>
    </Network>
    <Network ovf:name="NAT">
      <Description>Logical network used by this appliance.</Description>
    </Network>
  </NetworkSection>
  <VirtualSystem ovf:id="vagrant-$(optval os)-$(optval arch)">
    <Info>A virtual machine</Info>
    <VirtualHardwareSection>
      <Info>Virtual hardware requirements for a virtual machine</Info>
      <System>
        <vssd:ElementName>Virtual Hardware Family</vssd:ElementName>
        <vssd:InstanceID>0</vssd:InstanceID>
        <vssd:VirtualSystemIdentifier>vagrant-$(optval os)-$(optval arch)</vssd:VirtualSystemIdentifier>
        <vssd:VirtualSystemType>virtualbox-4.3</vssd:VirtualSystemType>
      </System>
      <Item>
        <rasd:Caption>1 virtual CPU</rasd:Caption>
        <rasd:Description>Number of virtual CPUs</rasd:Description>
        <rasd:ElementName>1 virtual CPU</rasd:ElementName>
        <rasd:InstanceID>1</rasd:InstanceID>
        <rasd:ResourceType>3</rasd:ResourceType>
        <rasd:VirtualQuantity>1</rasd:VirtualQuantity>
      </Item>
      <Item>
        <rasd:AllocationUnits>MegaBytes</rasd:AllocationUnits>
        <rasd:Caption>384 MB of memory</rasd:Caption>
        <rasd:Description>Memory Size</rasd:Description>
        <rasd:ElementName>384 MB of memory</rasd:ElementName>
        <rasd:InstanceID>2</rasd:InstanceID>
        <rasd:ResourceType>4</rasd:ResourceType>
        <rasd:VirtualQuantity>384</rasd:VirtualQuantity>
      </Item>
      <Item>
        <rasd:Address>0</rasd:Address>
        <rasd:Caption>sataController0</rasd:Caption>
        <rasd:Description>SATA Controller</rasd:Description>
        <rasd:ElementName>sataController0</rasd:ElementName>
        <rasd:InstanceID>5</rasd:InstanceID>
        <rasd:ResourceSubType>AHCI</rasd:ResourceSubType>
        <rasd:ResourceType>20</rasd:ResourceType>
      </Item>
      <Item>
        <rasd:AutomaticAllocation>true</rasd:AutomaticAllocation>
        <rasd:Caption>Ethernet adapter on 'NAT'</rasd:Caption>
        <rasd:Connection>NAT</rasd:Connection>
        <rasd:ElementName>Ethernet adapter on 'NAT'</rasd:ElementName>
        <rasd:InstanceID>6</rasd:InstanceID>
        <rasd:ResourceSubType>E1000</rasd:ResourceSubType>
        <rasd:ResourceType>10</rasd:ResourceType>
      </Item>
      <Item>
        <rasd:AutomaticAllocation>true</rasd:AutomaticAllocation>
        <rasd:Caption>Ethernet adapter on 'HostOnly'</rasd:Caption>
        <rasd:Connection>HostOnly</rasd:Connection>
        <rasd:ElementName>Ethernet adapter on 'HostOnly'</rasd:ElementName>
        <rasd:InstanceID>7</rasd:InstanceID>
        <rasd:ResourceSubType>E1000</rasd:ResourceSubType>
        <rasd:ResourceType>10</rasd:ResourceType>
      </Item>
      <Item>
        <rasd:AddressOnParent>0</rasd:AddressOnParent>
        <rasd:Caption>disk1</rasd:Caption>
        <rasd:Description>Disk Image</rasd:Description>
        <rasd:ElementName>disk1</rasd:ElementName>
        <rasd:HostResource>/disk/vmdisk1</rasd:HostResource>
        <rasd:InstanceID>10</rasd:InstanceID>
        <rasd:Parent>5</rasd:Parent>
        <rasd:ResourceType>17</rasd:ResourceType>
      </Item>
    </VirtualHardwareSection>
    <vbox:Machine ovf:required="false" version="ucib" uuid="{$(uuidgen)}" name="vagrant-$(optval os)-$(optval arch)" OSType="Linux" snapshotFolder="Snapshots" lastStateChange="$(date +%FT%TZ)">
      <ovf:Info>Complete VirtualBox machine configuration in VirtualBox format</ovf:Info>
      <ExtraData>
        <ExtraDataItem name="GUI/LastCloseAction" value="PowerOff"/>
        <ExtraDataItem name="GUI/LastGuestSizeHint" value="720,400"/>
        <ExtraDataItem name="GUI/LastNormalWindowPosition" value="0,44,1024,752"/>
        <ExtraDataItem name="GUI/LastScaleWindowPosition" value="320,309,640,480"/>
        <ExtraDataItem name="GUI/MiniToolBarAlignment" value="bottom"/>
        <ExtraDataItem name="GUI/SaveMountedAtRuntime" value="yes"/>
        <ExtraDataItem name="GUI/Scale" value="on"/>
        <ExtraDataItem name="GUI/ShowMiniToolBar" value="yes"/>
      </ExtraData>
      <Hardware version="2">
        <CPU count="1" hotplug="false">
          <HardwareVirtEx enabled="true" exclusive="false"/>
          <HardwareVirtExNestedPaging enabled="true"/>
          <HardwareVirtExVPID enabled="true"/>
          <PAE enabled="true"/>
          <HardwareVirtExLargePages enabled="false"/>
          <HardwareVirtForce enabled="false"/>
        </CPU>
        <Memory RAMSize="384" PageFusion="false"/>
        <HID Pointing="USBTablet" Keyboard="PS2Keyboard"/>
        <HPET enabled="false"/>
        <Chipset type="PIIX3"/>
        <Boot>
          <Order position="1" device="HardDisk"/>
          <Order position="2" device="None"/>
          <Order position="3" device="None"/>
          <Order position="4" device="None"/>
        </Boot>
        <Display VRAMSize="12" monitorCount="1" accelerate3D="false" accelerate2DVideo="false"/>
        <VideoRecording enabled="false" file="Test.webm" horzRes="640" vertRes="480"/>
        <RemoteDisplay enabled="false" authType="Null" authTimeout="5000"/>
        <BIOS>
          <ACPI enabled="true"/>
          <IOAPIC enabled="false"/>
          <Logo fadeIn="true" fadeOut="true" displayTime="0"/>
          <BootMenu mode="MessageAndMenu"/>
          <TimeOffset value="0"/>
          <PXEDebug enabled="false"/>
        </BIOS>
        <USBController enabled="true" enabledEhci="false"/>
        <Network>
          <Adapter slot="0" enabled="true" MACAddress="$macaddr" cable="true" speed="0" type="82540EM">
            <DisabledModes>
              <InternalNetwork name="intnet"/>
            </DisabledModes>
            <NAT>
              <DNS pass-domain="true" use-proxy="false" use-host-resolver="false"/>
              <Alias logging="false" proxy-only="false" use-same-ports="false"/>
            </NAT>
          </Adapter>
        </Network>
        <RTC localOrUTC="UTC"/>
        <SharedFolders/>
        <Clipboard mode="Disabled"/>
        <DragAndDrop mode="Disabled"/>
        <IO>
          <IoCache enabled="true" size="5"/>
          <BandwidthGroups/>
        </IO>
        <GuestProperties>
          <GuestProperty name="/VirtualBox/GuestAdd/Revision" value="92456" timestamp="1382633197437117000" flags=""/>
          <GuestProperty name="/VirtualBox/GuestAdd/Version" value="4.3.8" timestamp="1382633197436110000" flags=""/>
          <GuestProperty name="/VirtualBox/GuestAdd/VersionExt" value="4.3.8" timestamp="1382633197436602000" flags=""/>
          <GuestProperty name="/VirtualBox/GuestInfo/OS/Product" value="Linux" timestamp="1382633197433578000" flags=""/>
        </GuestProperties>
      </Hardware>
      <StorageControllers>
        <StorageController name="SATA" type="AHCI" PortCount="1" useHostIOCache="false" Bootable="true" IDE0MasterEmulationPort="0" IDE0SlaveEmulationPort="1" IDE1MasterEmulationPort="2" IDE1SlaveEmulationPort="3">
          <AttachedDevice type="HardDisk" port="0" device="0">
            <Image uuid="{$hdduuid}"/>
          </AttachedDevice>
        </StorageController>
      </StorageControllers>
    </vbox:Machine>
  </VirtualSystem>
</Envelope>
EOF

tar cf - -C "$WORKSPACE" ./metadata.json ./Vagrantfile ./box-disk1.vmdk ./box.ovf |pigz -c >"${OPTS[name]}.box"

info "Your box is now available in '${OPTS[name]}.box'"
