# frozen_string_literal: true

# Copyright 2018 Tristan Robert

# This file is part of ForemanFogProxmox.

# ForemanFogProxmox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# ForemanFogProxmox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with ForemanFogProxmox. If not, see <http://www.gnu.org/licenses/>.

module ForemanFogProxmox
  class ComputeResourcesController < ::ApplicationController
    before_action :load_compute_resource

    # GET foreman_fog_proxmox/isos/:storage
    def isos
      volumes = @compute_resource.isos(params[:storage])
      respond_to do |format|
        format.json { render :json => volumes }
      end
    end

    # GET foreman_fog_proxmox/node/statistics
    def node_statistics
      data = @compute_resource.node.statistics('rrd', { timeframe: 'hour', cf: 'AVERAGE', ds: 'loadavg' })
      filename = data['filename'].scan(/.+\/(\w+.[\w]{3})/).first.first
      img_data = Base64.encode64(data['image'])
      image = { filename: filename, data: img_data }
      respond_to do |format|
        format.json { render :json => image }
      end
    end

    private

    def load_compute_resource
      @compute_resource = ComputeResource.find_by(type: 'ForemanFogProxmox::Proxmox')
    end
  end
end